import pool from '../config/db.js';
import { sendTicketRaisedEmail, sendTicketRaisedToManagerEmail } from '../services/emailService.js';
export const createTicket = async (req, res) => {
  try {

    const userId = req.user.user_id;
    const { customer_type, agent_type } = req.user;

    const isCustomerSide =
      customer_type === "customer";

    const isAgentSide =
      agent_type === "normal";

    const {
      requester,
      contact_email,
      contact_phone,
      subject,
      description,
      category,
      sub_category,
      type,
      environment,
      priority,
      account_name,
      due_date,
      comment
    } = req.body;

    const userResult = await pool.query(
      `
      SELECT
        name,
        account_name,
        email,
        manager_id
      FROM users
      WHERE id = $1
      `,
      [userId]
    );

    if (userResult.rowCount === 0) {
      return res.status(400).json({ message: "User not found" });
    }

    const {
      name: dbRequester,
      account_name: dbAccountName,
      email: dbEmail,
      manager_id: managerId
    } = userResult.rows[0];

    if (isCustomerSide && !managerId) {
      return res.status(400).json({
        message: "Customer manager not assigned"
      });
    }


    if (requester !== dbRequester) {
      return res.status(400).json({
        message: "Requester name must match logged-in user"
      });
    }

    if (account_name !== dbAccountName) {
      return res.status(400).json({
        message: "Account name must match logged-in user"
      });
    }

    if (contact_email !== dbEmail) {
      return res.status(400).json({
        message: "Contact email must match logged-in user"
      });
    }

    if (
      !subject ||
      !description ||
      !category ||
      !sub_category ||
      !type ||
      !environment ||
      priority === undefined
    ) {
      return res.status(400).json({
        message: "All required fields must be provided"
      });
    }

    const categorySubCategoryMap = {
      SAP: ["MM", "SD", "FI", "ABAP", "BASIS"],
      Product: ["Vendor Portal", "Customer Portal", "Tax", "General"],
      Integration: ["Middleware"],
      Other: ["Other"]
    };

    if (
      !categorySubCategoryMap[category] ||
      !categorySubCategoryMap[category].includes(sub_category)
    ) {
      return res.status(400).json({
        message: "Invalid category or sub-category"
      });
    }

    if (![1, 2, 3, 4, 5].includes(Number(priority))) {
      return res.status(400).json({
        message: "Priority must be between 1 and 5"
      });
    }

    const slaMap = { 1: 6, 2: 12, 3: 24, 4: 48, 5: 64 };
    const sla_hours = slaMap[Number(priority)];

    let status;
    let approval_status;
    let approved_by = null;
    let approved_at = null;

    if (isCustomerSide) {
      status = "Unassigned";
      approval_status = "Pending";
    } else {
      status = "Open";
      approval_status = "Approved";
      approved_by = userId;
      approved_at = new Date();
    }

    const insertResult = await pool.query(
      `
      INSERT INTO tickets (
        requester_id,
        requester,
        contact_email,
        contact_phone,
        subject,
        description,
        category,
        sub_category,
        priority,
        account_name,
        due_date,
        sla_hours,
        status,
        approval_status,
        approved_by,
        approved_at,
        type,
        environment,
        comment
      )
      VALUES (
        $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,
        $11,$12,$13,$14,$15,$16,$17,$18,$19
      )
      RETURNING id
      `,
      [
        userId,                
        requester,             
        contact_email,         
        contact_phone || null, 
        subject,               
        description,           
        category,              
        sub_category,          
        priority,              
        account_name,          
        due_date || null,      
        sla_hours,             
        status,                
        approval_status,       
        approved_by,           
        approved_at,           
        type,                  
        environment,           
        comment || null        
      ]
    );

    const ticketId = insertResult.rows[0].id;

    // Note: File attachment upload feature is disabled (no S3 configured)
    // If you need file uploads, configure a local storage solution

    sendTicketRaisedEmail({
      to: dbEmail,
      ticket: {
        id: ticketId,
        subject,
        category,
        priority,
        status
      }
    }).catch(() => {});

    if (isCustomerSide && managerId) {
      const managerResult = await pool.query(
        `SELECT name, email FROM users WHERE id = $1`,
        [managerId]
      );

      if (managerResult.rowCount && managerResult.rows[0].email) {
        sendTicketRaisedToManagerEmail({
          to: managerResult.rows[0].email,
          ticket: { id: ticketId, subject, category, priority },
          customer: { name: dbRequester, email: dbEmail }
        }).catch(() => {});
      }
    }

   
    return res.status(201).json({
      message: isCustomerSide
        ? "Ticket submitted for manager approval"
        : "Ticket created successfully",
      ticketId
    });

  } catch (error) {
    console.error("Create ticket error:", error);
    return res.status(500).json({ message: error.message });
  }
};


export const myTickets = async (req, res) => {
  try {
    const userId = req.user.user_id; 

    const result = await pool.query(
      `SELECT
        t.id,
        t.subject,
        t.category,
        t.sub_category,
        t.type,
        t.environment,
        t.rca,
        t.status,
        t.priority,
        t.sla_hours,
        t.approval_status,
        t.created_at,
        t.updated_at,
        COALESCE(a.name, 'Not Assigned Yet') AS assignee_name,
        r.role_name AS assignee_role
       FROM tickets t
       LEFT JOIN users a ON t.assignee_id = a.id
       LEFT JOIN roles r ON a.role_id = r.id
       WHERE t.requester_id = $1
       ORDER BY t.created_at DESC`,
      [userId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error("Fetch my tickets error:", error);
    res.status(500).json({ message: "Server error" });
  }
};


export const addComment = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const { comment } = req.body;
    const userId = req.user.user_id;
    const userRole = req.user.role;

    if (!comment || comment.trim() === '') {
      return res.status(400).json({ message: 'Comment cannot be empty' });
    }

    await pool.query(
      `INSERT INTO ticket_comments (ticket_id, commented_by, comment_text, commented_role)
       VALUES ($1, $2, $3, $4)`,
      [ticketId, userId, comment, userRole]
    );

    res.status(201).json({ message: 'Comment added successfully' });

  } catch (error) {
    console.error('Add comment error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};


export const getTicketComments = async (req, res) => {
  try {
    const { ticketId } = req.params;

    const result = await pool.query(
      `SELECT
        tc.id,
        tc.comment_text,
        tc.comment_text AS comment,
        tc.comment_subject,
        tc.commented_role,
        tc.commented_role AS user_role,
        tc.created_at,
        u.id AS user_id,
        u.name AS commented_by_name,
        u.name AS user_name,
        r.role_name
       FROM ticket_comments tc
       JOIN users u ON tc.commented_by = u.id
       JOIN roles r ON u.role_id = r.id
       WHERE tc.ticket_id = $1
       ORDER BY tc.created_at ASC`,
      [ticketId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error('Get ticket comments error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
export const getMyProfile = async (req, res) => {
  try {
    const userId = req.user.user_id;

    const result = await pool.query(
      `
      SELECT
        u.id,
        u.name,
        u.email,
        u.phone,
        u.department,
        u.organization,
        u.account_name,
        u.is_active,
        u.created_at,
        r.role_name
      FROM users u
      JOIN roles r ON u.role_id = r.id
      WHERE u.id = $1
      `,
      [userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json(result.rows[0]);

  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};