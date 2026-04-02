import pool from '../config/db.js';
import {sendTicketRaisedEmail,sendTicketRaisedToManagerEmail,} from '../services/emailService.js';
export const getTicketDetails = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const userId = req.user.user_id;
    const role = req.user.role;
    const agentType = req.user.agent_type;

    let query = `
      SELECT
        t.*,
        c.name AS customer_name,
        a.name AS assignee_name
      FROM tickets t
      JOIN users c ON t.requester_id = c.id
      LEFT JOIN users a ON t.assignee_id = a.id
      WHERE t.id = $1
    `;

    const values = [ticketId];



    if (role === 'customer') {
      query += ` AND t.requester_id = $2`;
      values.push(userId);
    }

    if (role === 'agent') {
      if (agentType === 'normal') {
        query += `
          AND (
            t.assignee_id = $2
            OR (
              t.assignee_id IS NULL
              AND t.approval_status = 'Approved'
            )
          )
        `;
        values.push(userId);
      }

    }

    const result = await pool.query(query, values);

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: 'Ticket not found or access denied'
      });
    }

    res.json(result.rows[0]);

  } catch (error) {
    console.error('Get ticket details error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};




export const deleteTicket = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const userId = req.user.user_id;
    const role = req.user.role;

    let query = `DELETE FROM tickets WHERE id = $1`;
    const values = [ticketId];

    if (role === 'customer' || role === 'agent') {
      query += ` AND customer_id = $2`;
      values.push(userId);
    }


    const result = await pool.query(query + ' RETURNING id', values);

    if (result.rowCount === 0) {
      return res.status(403).json({
        message: 'You are not allowed to delete this ticket or ticket not found'
      });
    }

    res.json({ message: 'Ticket deleted successfully' });

  } catch (error) {
    console.error('Delete ticket error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const updateTicket = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const userId = req.user.user_id;
    const role = req.user.role;
    const agentType = req.user.agent_type;

    const allowedFields = [
      'contact_name',
      'contact_email',
      'contact_phone',
      'account_name',
      'category',
      'subject',
      'description',
      'product_name',
      'due_date',
      'language',
      'priority',
      'channel',
      'classification'
    ];

    const updates = [];
    const values = [];
    let index = 1;

    for (const field of allowedFields) {
      if (req.body[field] !== undefined) {
        updates.push(`${field} = $${index}`);
        values.push(req.body[field]);
        index++;
      }
    }

    if (updates.length === 0) {
      return res.status(400).json({
        message: 'No valid fields provided for update'
      });
    }

    let query = `
      UPDATE tickets
      SET ${updates.join(', ')},
          updated_at = CURRENT_TIMESTAMP
      WHERE id = $${index}
    `;
    values.push(ticketId);
    index++;

    if (role === 'customer') {
      query += ` AND customer_id = $${index}`;
      values.push(userId);
    }


    if (role === 'agent') {
      if (agentType !== 'admin') {
        return res.status(403).json({
          message: 'Only admin can update tickets'
        });
      }
   
    }

    const result = await pool.query(query + ' RETURNING id', values);

    if (result.rowCount === 0) {
      return res.status(403).json({
        message: 'Ticket not found or access denied'
      });
    }

    res.json({ message: 'Ticket updated successfully' });

  } catch (error) {
    console.error('Update ticket error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const updateTicketStatus = async (req, res) => {
  try {
    const { ticketId } = req.params;
    const { status } = req.body;

    const userId = req.user.user_id;
    const role = req.user.role;
    const customerType = req.user.customer_type;

    const allowedStatuses = [
      'unassigned',
      'open',
      'assigned',
      'requirements',
      'developments',
      'uat',
      'closed'
    ];

    if (!status || !allowedStatuses.includes(status)) {
      return res.status(400).json({
        message: 'Invalid status value'
      });
    }


    if (role === 'customer' && customerType !== 'manager') {
      return res.status(403).json({
        message: 'Only manager can update ticket status'
      });
    }

   
    let query = `
      UPDATE tickets
      SET status = $1,
          updated_at = CURRENT_TIMESTAMP
      WHERE id = $2
    `;
    const values = [status, ticketId];

    if (role === 'customer' && customerType === 'manager') {
      query += `
        AND customer_id IN (
          SELECT id FROM users WHERE manager_id = $3
        )
      `;
      values.push(userId);
    }

    if (role === 'agent') {
      query += `
        AND assignee_id = $3
      `;
      values.push(userId);
    }

    const result = await pool.query(query + ' RETURNING id, status', values);

    if (result.rowCount === 0) {
      return res.status(403).json({
        message: 'Ticket not found or access denied'
      });
    }

    res.json({
      message: 'Ticket status updated successfully',
      ticket: result.rows[0]
    });

  } catch (error) {
    console.error('Update ticket status error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};


