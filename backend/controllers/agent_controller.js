import pool from '../config/db.js';
import { sendAgentCommentEmail } from '../services/emailService.js';


export const getUnassignedTickets = async (req, res) => {
  try {
    const result = await pool.query(
      `
      SELECT
        t.*,
        m.email AS approved_by_email
      FROM tickets t
      LEFT JOIN users m ON t.approved_by = m.id
      WHERE t.assignee_id IS NULL
        AND t.approval_status = 'Approved'
      ORDER BY t.created_at DESC
      `
    );

    res.json(result.rows);

  } catch (error) {
    console.error('Get unassigned tickets error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};




export const pickTicket = async (req, res) => {
  try{
   const agentId = req.user.user_id;
    const { ticketId } = req.params;

    const result = await pool.query(
      `
      UPDATE tickets
      SET
        assignee_id = $1,
        assigned_by = $1,               -- self assigned
        assigned_at = CURRENT_TIMESTAMP,
        status = 'Assigned',
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $2
        AND assignee_id IS NULL
        AND approval_status = 'Approved'
      RETURNING id
      `,
      [agentId, ticketId]
    );

    if (result.rowCount === 0) {
      return res.status(400).json({
        message: 'Ticket already assigned or not approved'
      });
    }

    res.json({ message: 'Ticket self-assigned successfully' });

  } catch (error) {
    console.error('Self assign ticket error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const myAssignedTickets = async (req, res) => {
  try {
    const agentId = req.user.user_id;

    const result = await pool.query(
      `
      SELECT
        t.*,

        -- Assigned by info
        ab.name AS assigned_by_name,
        ab.email AS assigned_by_email,
        abr.role_name AS assigned_by_role,

        -- ✅ CORRECT REQUESTER TYPE (ID BASED)
        CASE
          WHEN rr.role_name = 'agent' THEN ru.agent_type
          WHEN rr.role_name = 'customer' THEN ru.customer_type
          ELSE rr.role_name
        END AS requester_type,

        CASE
          WHEN t.assigned_by = t.assignee_id THEN 'Self Assigned'
          ELSE 'Assigned by Manager'
        END AS assignment_type

      FROM tickets t

      -- Assigned by
      LEFT JOIN users ab ON t.assigned_by = ab.id
      LEFT JOIN roles abr ON ab.role_id = abr.id

      -- 🔥 Requester (FIXED: ID based join)
      LEFT JOIN users ru ON t.requester_id = ru.id
      LEFT JOIN roles rr ON ru.role_id = rr.id

      WHERE t.assignee_id = $1
      ORDER BY t.assigned_at DESC
      `,
      [agentId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error('My assigned tickets error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};



/**
 * Normal Agent: Escalate ticket to admin
 */
export const escalateToAdmin = async (req, res) => {
  try {
    const agentId = req.user.user_id;
    const { ticketId } = req.params;
    const { reason } = req.body;

    if (!reason) {
      return res.status(400).json({
        message: 'Escalation reason is required'
      });
    }

    // Ensure ticket is assigned to this agent
    const ticketCheck = await pool.query(
      `
      SELECT id
      FROM tickets
      WHERE id = $1
        AND assignee_id = $2
      `,
      [ticketId, agentId]
    );

    if (ticketCheck.rows.length === 0) {
      return res.status(403).json({
        message: 'You are not allowed to escalate this ticket'
      });
    }

    // Find admin
    const adminResult = await pool.query(
      `
      SELECT id FROM users
      WHERE agent_type = 'admin'
      LIMIT 1
      `
    );

    if (adminResult.rows.length === 0) {
      return res.status(500).json({
        message: 'No admin found'
      });
    }

    const adminId = adminResult.rows[0].id;

    // Escalate
    await pool.query(
      `
      UPDATE tickets
      SET status = 'Escalated',
          assignee_id = NULL,
          escalated_to = $1,
          escalation_reason = $2,
          updated_at = CURRENT_TIMESTAMP
      WHERE id = $3
      `,
      [adminId, reason, ticketId]
    );

    await pool.query(
      `
      INSERT INTO ticket_status_logs
      (ticket_id, old_status, new_status, changed_by)
      VALUES ($1,'InProgress','Escalated',$2)
      `,
      [ticketId, agentId]
    );

    res.json({ message: 'Ticket escalated to admin' });

  } catch (error) {
    console.error('Escalate to admin error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};


export const closeTicket = async (req, res) => {
  try {
    const { ticketId } = req.params;

    const result = await pool.query(
      `UPDATE tickets
       SET status = 'Closed',
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $1
       AND assignee_id = $2`,
      [ticketId, req.user.user_id]
    );

    if (result.rowCount === 0) {
      return res.status(403).json({
        message: 'You are not assigned to this ticket'
      });
    }

    res.json({ message: 'Ticket closed successfully' });

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
};

export const agentTickets = async (req, res) => {
  try {
    const agentId = req.user.user_id;

    const result = await pool.query(
      `SELECT
        t.id,
        t.subject,
        t.description,
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
        u.name  AS requester_name,
        u.email AS requester_email,
        u.account_name,
        COALESCE(a.name, 'Not Assigned Yet') AS assignee_name   -- ✅ SAME PATTERN
       FROM tickets t
       JOIN users u ON t.requester_id = u.id
       LEFT JOIN users a ON t.assignee_id = a.id
       WHERE t.assignee_id = $1
       ORDER BY t.created_at DESC`,
      [agentId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error('Fetch agent tickets error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};


export const getTicketById = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const agentId = req.user.user_id;

    /* ================= BASIC VALIDATION ================= */
    if (!ticketId || isNaN(ticketId)) {
      return res.status(400).json({ message: 'Invalid ticket id' });
    }

    /* =================================================
       FETCH TICKET (AGENT ACCESS CHECK)
    ================================================= */
    const result = await pool.query(
      `
      SELECT
        t.id,
        t.subject,
        COALESCE(t.description, 'Not given') AS description,
        t.contact_phone,
        t.category,
        t.sub_category,
        t.type,
        t.environment,
        COALESCE(t.rca, 'Not Given Yet') AS rca,
        COALESCE(t.resolution, 'Not Given Yet') AS resolution,
        t.status,
        t.priority,
        t.sla_hours,
        t.approval_status,
        t.created_at,
        t.updated_at,

        u.name  AS requester_name,
        u.email AS requester_email,
        u.account_name,

        COALESCE(a.name, 'Not Assigned Yet') AS assignee_name

      FROM tickets t
      JOIN users u ON t.requester_id = u.id
      LEFT JOIN users a ON t.assignee_id = a.id
      WHERE t.assignee_id = $1
        AND t.id = $2
      `,
      [agentId, ticketId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({
        message: 'Ticket not found or not assigned to you'
      });
    }

    const ticket = result.rows[0];

    /* =================================================
       FETCH COMMENTS
    ================================================= */
    const commentsResult = await pool.query(
      `
      SELECT
        tc.id,
        tc.comment_text,
        tc.commented_role,
        tc.created_at,
        u.name AS commented_by_name
      FROM ticket_comments tc
      JOIN users u ON tc.commented_by = u.id
      WHERE tc.ticket_id = $1
      ORDER BY tc.created_at ASC
      `,
      [ticketId]
    );

    /* =================================================
       FETCH ATTACHMENTS
    ================================================= */
    const attachmentsResult = await pool.query(
      `
      SELECT
        ta.id,
        ta.file_name,
        ta.file_path,
        ta.uploaded_at
      FROM ticket_attachments ta
      WHERE ta.ticket_id = $1
      ORDER BY ta.uploaded_at ASC
      `,
      [ticketId]
    );

    /* =================================================
       PREPARE ATTACHMENTS (without S3 signed URLs)
    ================================================= */
    const attachments = attachmentsResult.rows.map(att => ({
      id: att.id,
      file_name: att.file_name,
      file_path: att.file_path,
      uploaded_at: att.uploaded_at
    }));

    /* =================================================
       FINAL RESPONSE
    ================================================= */
    return res.json({
      ticket,
      comments: commentsResult.rows,
      attachments
    });

  } catch (error) {
    console.error('Fetch agent ticket by ID error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const agentUpdateTicket = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const agentId = req.user.user_id;

    const {
      status: newStatus,
      rca,
      resolution,
      waiting_for_customer
    } = req.body || {};

    /* =================================================
       FLEXIBLE STATUS TRANSITIONS
       Agents can move to any valid status except:
       - Cannot go back to Open/Unassigned
       - Closed is final (cannot change from Closed)
    ================================================= */
    const validStatuses = [
      'Assigned',
      'Requirements',
      'Development',
      'Internal Testing',
      'UAT',
      'Resolved',
      'Closed'
    ];

    /* =================================================
       FETCH CURRENT STATUS + WAITING FLAG
    ================================================= */
    const result = await pool.query(
      `
      SELECT
        t.status,
        t.waiting_for_customer
      FROM tickets t
      WHERE t.id = $1
        AND t.assignee_id = $2
      `,
      [ticketId, agentId]
    );

    if (result.rowCount === 0) {
      return res.status(403).json({
        message: 'You are not assigned to this ticket'
      });
    }

    const {
      status: currentStatus,
      waiting_for_customer: currentWaiting
    } = result.rows[0];

    /* =================================================
       STATUS VALIDATION
    ================================================= */
    if (newStatus) {
      if (currentWaiting === true) {
        return res.status(400).json({
          message: 'Cannot change status while waiting for customer'
        });
      }

      // Cannot change from Closed status
      if (currentStatus === 'Closed') {
        return res.status(400).json({
          message: 'Cannot change status of a closed ticket'
        });
      }

      // Validate new status is a valid status
      if (!validStatuses.includes(newStatus)) {
        return res.status(400).json({
          message: `Invalid status. Valid statuses: ${validStatuses.join(', ')}`
        });
      }

      // Cannot go back to Open or Unassigned
      if (newStatus === 'Open' || newStatus === 'Unassigned') {
        return res.status(400).json({
          message: 'Cannot change status back to Open or Unassigned'
        });
      }

      // RCA and Resolution required for Resolved/Closed
      if (newStatus === 'Resolved' || newStatus === 'Closed') {
        if (!rca || !resolution) {
          return res.status(400).json({
            message: 'RCA and Resolution are mandatory for Resolved / Closed'
          });
        }
      }
    }

    /* =================================================
       BUILD UPDATE QUERY
    ================================================= */
    const updates = [];
    const values = [];
    let index = 1;

    if (typeof waiting_for_customer === 'boolean') {
      updates.push(`waiting_for_customer = $${index}`);
      values.push(waiting_for_customer);
      index++;
    }

    if (newStatus) {
      updates.push(`status = $${index}`);
      values.push(newStatus);
      index++;
    }

    if (rca !== undefined) {
      updates.push(`rca = $${index}`);
      values.push(rca);
      index++;
    }

    if (resolution !== undefined) {
      updates.push(`resolution = $${index}`);
      values.push(resolution);
      index++;
    }

    if (updates.length === 0) {
      return res.status(400).json({
        message: 'No valid fields provided for update'
      });
    }

    /* =================================================
       UPDATE
    ================================================= */
    const updateQuery = `
      UPDATE tickets
      SET ${updates.join(', ')},
          updated_at = CURRENT_TIMESTAMP
      WHERE id = $${index}
        AND assignee_id = $${index + 1}
      RETURNING id
    `;

    values.push(ticketId, agentId);
    await pool.query(updateQuery, values);

    /* =================================================
       FETCH UPDATED TICKET
    ================================================= */
    const ticketResult = await pool.query(
      `
      SELECT
        t.id,
        t.subject,
        t.contact_phone,
        t.description,
        t.category,
        t.sub_category,
        t.type,
        t.environment,
        t.status,
        t.waiting_for_customer,
        t.priority,
        t.sla_hours,
        t.approval_status,
        t.rca,
        t.resolution,
        t.created_at,
        t.updated_at,

        c.name  AS requester_name,
        c.email AS requester_email,
        c.account_name,

        a.name  AS assignee_name

      FROM tickets t
      JOIN users c  ON t.requester_id = c.id
      LEFT JOIN users a  ON t.assignee_id = a.id
      WHERE t.id = $1
      `,
      [ticketId]
    );

    return res.json({
      message: 'Ticket updated successfully',
      ticket: ticketResult.rows[0]
    });

  } catch (error) {
    console.error('Agent update ticket error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};



export const agentAddComment = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const agentId = req.user.user_id;

    const { subject, comment } = req.body;

    /* =================================================
       BASIC VALIDATION
    ================================================= */
    if (!comment) {
      return res.status(400).json({
        message: 'Comment is required'
      });
    }

    /* =================================================
       FETCH TICKET + OWNERSHIP + EMAILS
    ================================================= */
    const ticketResult = await pool.query(
      `
      SELECT
        t.assignee_id,
        c.email  AS customer_email
      FROM tickets t
      JOIN users c ON t.requester_id = c.id
      WHERE t.id = $1
      `,
      [ticketId]
    );

    if (ticketResult.rowCount === 0) {
      return res.status(404).json({
        message: 'Ticket not found'
      });
    }

    const ticket = ticketResult.rows[0];

    if (ticket.assignee_id !== agentId) {
      return res.status(403).json({
        message: 'You are not assigned to this ticket'
      });
    }

    /* =================================================
       SAVE COMMENT IN DB
    ================================================= */
    await pool.query(
      `
      INSERT INTO ticket_comments (
        ticket_id,
        commented_by,
        comment_subject,
        comment_text,
        commented_role
      )
      VALUES ($1, $2, $3, $4, $5)
      `,
      [
        ticketId,
        agentId,
        subject || null,   // optional
        comment,
        'agent'
      ]
    );

    /* =================================================
       SEND EMAIL TO CUSTOMER (NON-BLOCKING)
    ================================================= */
    if (ticket.customer_email) {
      sendAgentCommentEmail({
        to: ticket.customer_email,
        ticketId,
        subject,
        comment,
        recipientType: 'customer'
      }).catch(err =>
        console.error('Customer comment email failed:', err.message)
      );
    }

    /* =================================================
       RESPONSE
    ================================================= */
    return res.json({
      message: 'Comment added successfully'
    });

  } catch (error) {
    console.error('Agent add comment error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};



export const getTicketComments = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const userId = req.user.user_id;

    const ticketResult = await pool.query(
      `
      SELECT assignee_id
      FROM tickets
      WHERE id = $1
      `,
      [ticketId]
    );

    if (ticketResult.rowCount === 0) {
      return res.status(404).json({ message: 'Ticket not found' });
    }

    const { assignee_id } = ticketResult.rows[0];

    if (assignee_id !== userId) {
      return res.status(403).json({
        message: 'You are not allowed to view comments for this ticket'
      });
    }

    const commentsResult = await pool.query(
      `
      SELECT
        tc.id,
        tc.comment_text,
        tc.commented_role,
        tc.created_at,
        u.name               AS commented_by_name
      FROM ticket_comments tc
      JOIN users u ON tc.commented_by = u.id
      WHERE tc.ticket_id = $1
      ORDER BY tc.created_at ASC
      `,
      [ticketId]
    );
    res.json(commentsResult.rows);

  } catch (error) {
    console.error('Get ticket comments error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
