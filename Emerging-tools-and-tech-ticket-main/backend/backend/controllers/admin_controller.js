import pool from '../config/db.js';
import bcrypt from 'bcrypt';
import { sendUserCredentialsEmail } from '../services/emailService.js';

function generateTempPassword(length = 12) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%';
  let password = '';
  for (let i = 0; i < length; i++) {
    password += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return password;
}
export const oldaddUser = async (req, res) => {
  try {
    const {
      name,
      email,
      role,
      phone,
      department,
      organization,
      account_name,
      agent_type,
      customer_type,
      delivery_lead_email,
      manager_email
    } = req.body;


    if (!name || !email || !role || !account_name) {
      return res.status(400).json({
        message: 'name, email, role and account_name are required'
      });
    }

    const roleResult = await pool.query(
      `SELECT id FROM roles WHERE role_name = $1`,
      [role]
    );

    if (roleResult.rows.length === 0) {
      return res.status(400).json({ message: 'Invalid role' });
    }

    const roleId = roleResult.rows[0].id;

    let deliveryLeadId = null;
    let resolvedDeliveryLeadEmail = null;
    let resolvedManagerEmail = null;

    if (role === 'customer') {
      if (!customer_type) {
        return res.status(400).json({
          message: 'customer_type is required for customer'
        });
      }

      if (customer_type === 'customer') {
        if (!manager_email || !delivery_lead_email) {
          return res.status(400).json({
            message:
              'manager_email and delivery_lead_email are required for customer'
          });
        }


        const managerResult = await pool.query(
          `
          SELECT id, email FROM users
          WHERE email = $1
            AND role_id = (SELECT id FROM roles WHERE role_name = 'customer')
            AND customer_type = 'manager'
          `,
          [manager_email]
        );

        if (managerResult.rows.length === 0) {
          return res.status(400).json({ message: 'Invalid customer manager email' });
        }

        resolvedManagerEmail = managerResult.rows[0].email;


        const leadResult = await pool.query(
          `
          SELECT id, email FROM users
          WHERE email = $1
            AND role_id = (SELECT id FROM roles WHERE role_name = 'agent')
            AND agent_type = 'delivery_lead'
          `,
          [delivery_lead_email]
        );

        if (leadResult.rows.length === 0) {
          return res.status(400).json({ message: 'Invalid delivery lead email' });
        }

        deliveryLeadId = leadResult.rows[0].id;
        resolvedDeliveryLeadEmail = leadResult.rows[0].email;
      }

  
      if (customer_type === 'manager') {
        if (manager_email || delivery_lead_email) {
          return res.status(400).json({
            message: 'Customer manager cannot have manager or delivery lead'
          });
        }
      }
    }

    if (role === 'agent') {
      if (!agent_type) {
        return res.status(400).json({
          message: 'agent_type is required for agent'
        });
      }

      if (agent_type === 'normal') {
        if (!delivery_lead_email) {
          return res.status(400).json({
            message: 'delivery_lead_email is required for normal agent'
          });
        }

        const leadResult = await pool.query(
          `
          SELECT id, email FROM users
          WHERE email = $1
            AND agent_type = 'delivery_lead'
          `,
          [delivery_lead_email]
        );

        if (leadResult.rows.length === 0) {
          return res.status(400).json({
            message: 'Invalid delivery lead email'
          });
        }

        deliveryLeadId = leadResult.rows[0].id;
        resolvedDeliveryLeadEmail = leadResult.rows[0].email;
      }

      if (['delivery_lead', 'hod', 'admin'].includes(agent_type)) {
        if (delivery_lead_email) {
          return res.status(400).json({
            message: `${agent_type} should not have delivery_lead_email`
          });
        }
      }
    }

    const emailCheck = await pool.query(
      `SELECT id FROM users WHERE email = $1`,
      [email]
    );
    if (emailCheck.rows.length > 0) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    const accountCheck = await pool.query(
      `SELECT id FROM users WHERE account_name = $1`,
      [account_name]
    );
    if (accountCheck.rows.length > 0) {
      return res.status(400).json({ message: 'Account name already exists' });
    }

    const tempPassword = generateTempPassword();
    const passwordHash = await bcrypt.hash(tempPassword, 10);

    await pool.query(
      `
      INSERT INTO users (
        name,
        email,
        password_hash,
        role_id,
        customer_type,
        agent_type,
        delivery_lead_id,
        phone,
        department,
        organization,
        account_name
      )
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
      `,
      [
        name,
        email,
        passwordHash,
        roleId,
        customer_type || null,
        agent_type || null,
        deliveryLeadId,
        phone || null,
        department || null,
        organization || null,
        account_name
      ]
    );

    sendUserCredentialsEmail({
      to: email,
      name,
      email,
      role,
      agent_type,
      customer_type,
      account_name,
      tempPassword,
      manager_email: resolvedManagerEmail,
      delivery_lead_email: resolvedDeliveryLeadEmail
    }).catch(err => console.error('Email error:', err.message));

    res.status(201).json({
      message: 'User created successfully and credentials emailed'
    });

  } catch (error) {
    console.error('Add user error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};





export const addUser = async (req, res) => {
  try {
    const {
      name,
      email,
      role,
      phone,
      department,
      organization,
      account_name,
      agent_type,
      customer_type,
      manager_email
    } = req.body;


    if (!name || !email || !role || !account_name) {
      return res.status(400).json({
        message: 'name, email, role and account_name are required'
      });
    }


    const roleResult = await pool.query(
      `SELECT id FROM roles WHERE role_name = $1`,
      [role]
    );

    if (roleResult.rows.length === 0) {
      return res.status(400).json({ message: 'Invalid role' });
    }

    const roleId = roleResult.rows[0].id;

    let managerId = null;
    let resolvedManagerEmail = null;

    if (role === 'customer') {
      if (!customer_type) {
        return res.status(400).json({
          message: 'customer_type is required for customer'
        });
      }

    
      if (customer_type === 'customer') {
        if (!manager_email) {
          return res.status(400).json({
            message:
              'manager_email is required for customer'
          });
        }

        const managerResult = await pool.query(
          `
          SELECT id, email
          FROM users
          WHERE email = $1
            AND role_id = (SELECT id FROM roles WHERE role_name = 'customer')
            AND customer_type = 'manager'
          `,
          [manager_email]
        );

        if (managerResult.rows.length === 0) {
          return res.status(400).json({
            message: 'Invalid customer manager email'
          });
        }

        managerId = managerResult.rows[0].id;
        resolvedManagerEmail = managerResult.rows[0].email;
      }

  
      if (customer_type === 'manager') {
        if (manager_email) {
          return res.status(400).json({
            message: 'Customer manager cannot have a manager'
          });
        }
      }
    }

    if (role === 'agent') {
      if (!agent_type) {
        return res.status(400).json({
          message: 'agent_type is required for agent'
        });
      }
    }

    const emailCheck = await pool.query(
      `SELECT id FROM users WHERE email = $1`,
      [email]
    );
    if (emailCheck.rows.length > 0) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    const accountCheck = await pool.query(
      `SELECT id FROM users WHERE account_name = $1`,
      [account_name]
    );
    if (accountCheck.rows.length > 0) {
      return res.status(400).json({
        message: 'Account name already exists'
      });
    }

    const tempPassword = generateTempPassword();
    const passwordHash = await bcrypt.hash(tempPassword, 10);

    await pool.query(
      `
      INSERT INTO users (
        name,
        email,
        password_hash,
        role_id,
        customer_type,
        agent_type,
        manager_id,
        phone,
        department,
        organization,
        account_name
      )
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
      `,
      [
        name,
        email,
        passwordHash,
        roleId,
        customer_type || null,
        agent_type || null,
        managerId,
        phone || null,
        department || null,
        organization || null,
        account_name
      ]
    );

  
    console.log('📧 Attempting to send credentials email to:', email);
    sendUserCredentialsEmail({
      to: email,
      name,
      email,
      role,
      agent_type,
      customer_type,
      account_name,
      tempPassword,
      manager_email: resolvedManagerEmail
    })
    .then(() => console.log('✅ Email sent successfully to:', email))
    .catch(err => {
      console.error('❌ Email error:', err.message);
      console.error('Full error:', err);
    });

    res.status(201).json({
      message: 'User created successfully and credentials emailed'
    });

  } catch (error) {
    console.error('Add user error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
