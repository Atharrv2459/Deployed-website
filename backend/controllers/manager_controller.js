import pool from '../config/db.js';
export const getPendingTicketsForApproval = async (req, res) => {
  try {
    const managerId = req.user.user_id;
    const result = await pool.query(
      `
      SELECT
        t.*,

        CASE
          WHEN rr.role_name = 'agent' THEN r.agent_type
          WHEN rr.role_name = 'customer' THEN r.customer_type
          ELSE rr.role_name
        END AS requester_type

      FROM tickets t
      LEFT JOIN users r ON t.requester_id = r.id
      LEFT JOIN roles rr ON r.role_id = rr.id

      WHERE t.approval_status = 'Pending'
        AND r.manager_id = $1

      ORDER BY t.created_at DESC
      `,
      [managerId]
    );
    res.json(result.rows);
  } catch (error) {
    console.error("Pending approval error:", error);
    res.status(500).json({ message: "Server error" });
  }
};





export const approveOrRejectTicket = async (req, res) => {
  try {
    const managerId = req.user.user_id;
    const { ticketId } = req.params;
    let { action, rejection_reason } = req.body;
    if (!action && req.body.approval_status) {
      action = req.body.approval_status;
    }
    if (!action) {
      return res.status(400).json({
        message: "Action is required"
      });
    }
    action = action.toString().trim().toLowerCase();
    if (action === 'approved') action = 'approve';
    if (action === 'rejected') action = 'reject';
    if (!['approve', 'reject'].includes(action)) {
      return res.status(400).json({
        message: "Action must be either approve or reject"
      });
    }
    const ticketResult = await pool.query(
      `
      SELECT
        t.id,
        t.subject,
        t.description
      FROM tickets t
      JOIN users r ON t.requester_id = r.id
      WHERE t.id = $1
        AND t.approval_status = 'Pending'
        AND r.manager_id = $2
      `,
      [ticketId, managerId]
    );
    if (ticketResult.rowCount === 0) {
      return res.status(403).json({
        message: "Ticket not found, already processed, or access denied"
      });
    }
    const ticket = ticketResult.rows[0];
    if (action === "approve") {
      await pool.query(
        `
        UPDATE tickets
        SET
          approval_status = 'Approved',
          approved_by = $1,
          approved_at = CURRENT_TIMESTAMP,
          status = 'Open',
          updated_at = CURRENT_TIMESTAMP
        WHERE id = $2
        `,
        [managerId, ticketId]
      );
      return res.json({ message: "Ticket approved successfully" });
    }
    if (!rejection_reason || rejection_reason.trim() === "") {
      return res.status(400).json({
        message: "rejection_reason is required when rejecting a ticket"
      });
    }
    await pool.query(
      `
      UPDATE tickets
      SET
        approval_status = 'Rejected',
        rejection_reason = $1,
        approved_by = $2,
        approved_at = CURRENT_TIMESTAMP,
        status = 'Closed',
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $3
      `,
      [rejection_reason, managerId, ticketId]
    );

    return res.json({ message: "Ticket rejected successfully" });

  } catch (error) {
    console.error("Approve / Reject ticket error:", error);
    res.status(500).json({ message: "Server error" });
  }
};


export const getCustomersUnderManager = async (req, res) => {
  try {
    const managerId = req.user.user_id;

    const result = await pool.query(
      `
      SELECT
        id,
        name,
        email,
        phone,
        department,
        organization,
        account_name,
        is_active,
        created_at
      FROM users
      WHERE role_id = (SELECT id FROM roles WHERE role_name = 'customer')
        AND customer_type = 'customer'
        AND manager_id = $1
      ORDER BY created_at DESC
      `,
      [managerId]
    );

    res.json(result.rows);
  } catch (error) {
    console.error('Get customers under manager error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
export const rejectTicketWithReason = async (req, res) => {
  try {
    const managerId = req.user.user_id;
    const { ticketId } = req.params;
    const { rejection_reason } = req.body;

    /* ---------- VALIDATION ---------- */
    if (!rejection_reason || rejection_reason.trim() === '') {
      return res.status(400).json({
        message: 'rejection_reason is required'
      });
    }

    /* ---------- FETCH TICKET + CUSTOMER EMAIL ---------- */
    const ticketResult = await pool.query(
      `
      SELECT 
        t.id,
        t.subject,
        u.email AS customer_email
      FROM tickets t
      JOIN users u ON t.requester_id = u.id
      WHERE t.id = $1
        AND u.manager_id = $2
        AND t.approval_status = 'Pending'
      `,
      [ticketId, managerId]
    );

    if (ticketResult.rows.length === 0) {
      return res.status(403).json({
        message: 'Ticket not found or access denied'
      });
    }

    /* ---------- UPDATE TICKET ---------- */
    await pool.query(
      `
      UPDATE tickets
      SET
        approval_status = 'Rejected',
        rejection_reason = $1,
        approved_by = $2,
        approved_at = CURRENT_TIMESTAMP,
        status = 'Closed',
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $3
      `,
      [rejection_reason, managerId, ticketId]
    );
// 🔔 Notification → Customer
await createNotification({
  userId: ticketResult.rows[0].customer_id,
  title: 'Ticket Rejected',
  message: `Your ticket #${ticketId} was rejected. Reason: ${rejection_reason}`
});

    /* ---------- SEND EMAIL TO CUSTOMER ---------- */
    const customerEmail = ticketResult.rows[0].customer_email;

    if (customerEmail) {
      sendTicketRejectedEmail({
        to: customerEmail,
        ticket: {
          id: ticketResult.rows[0].id,
          subject: ticketResult.rows[0].subject,
          rejection_reason
        }
      }).catch(err => {
        console.error('Ticket rejection email failed:', err.message);
      });
    }

    return res.json({
      message: 'Ticket rejected successfully and email sent to customer'
    });

  } catch (error) {
    console.error('Reject ticket error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};


export const getApprovedTicketsForManager = async (req, res) => {
  try {
    const managerId = req.user.user_id;

    const result = await pool.query(
      `
      SELECT
        t.id,
        t.subject,
        t.category,
        t.priority,
        t.status,
        t.approval_status,
        t.created_at,
        t.updated_at,
        r.name  AS requester_name,
        r.email AS requester_email,

        CASE
          WHEN rr.role_name = 'agent' THEN r.agent_type
          WHEN rr.role_name = 'customer' THEN r.customer_type
          ELSE rr.role_name
        END AS requester_type

      FROM tickets t
      JOIN users r ON t.requester_id = r.id
      LEFT JOIN roles rr ON r.role_id = rr.id

      WHERE t.approval_status = 'Approved'
        AND t.approved_by = $1
        AND r.manager_id = $1

      ORDER BY t.created_at DESC
      `,
      [managerId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error("Get approved tickets error:", error);
    res.status(500).json({ message: "Server error" });
  }
};



export const getRejectedTicketsForManager = async (req, res) => {
  try {
    const managerId = req.user.user_id;

    const result = await pool.query(
      `
      SELECT
        t.id,
        t.subject,
        t.category,
        t.priority,
        t.status,
        t.approval_status,
        t.rejection_reason,
        t.created_at,
        t.updated_at,
        r.name  AS requester_name,
        r.email AS requester_email,

        CASE
          WHEN rr.role_name = 'agent' THEN r.agent_type
          WHEN rr.role_name = 'customer' THEN r.customer_type
          ELSE rr.role_name
        END AS requester_type

      FROM tickets t
      JOIN users r ON t.requester_id = r.id
      LEFT JOIN roles rr ON r.role_id = rr.id

      WHERE t.approval_status = 'Rejected'
        AND t.approved_by = $1
        AND r.manager_id = $1

      ORDER BY t.created_at DESC
      `,
      [managerId]
    );

    res.json(result.rows);

  } catch (error) {
    console.error("Get rejected tickets error:", error);
    res.status(500).json({ message: "Server error" });
  }
};


