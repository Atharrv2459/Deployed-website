import bcrypt from 'bcrypt';
import pool from './db.js';

export const bootstrapAdmin = async () => {
  // Check if an admin agent already exists
  const adminExists = await pool.query(`
    SELECT 1 FROM users u
    JOIN roles r ON u.role_id = r.id
    WHERE r.role_name = 'agent' AND u.agent_type = 'admin'
  `);

  if (adminExists.rows.length > 0) return;

  // Get the 'agent' role id
  const role = await pool.query(
    `SELECT id FROM roles WHERE role_name = 'agent'`
  );

  if (role.rows.length === 0) {
    console.log('❌ Agent role not found in database');
    return;
  }

  const hash = await bcrypt.hash(
    process.env.INITIAL_ADMIN_PASSWORD,
    10
  );

  await pool.query(
    `INSERT INTO users (name, email, password_hash, role_id, agent_type, account_name)
     VALUES ($1, $2, $3, $4, $5, $6)`,
    [
      process.env.INITIAL_ADMIN_NAME,
      process.env.INITIAL_ADMIN_EMAIL,
      hash,
      role.rows[0].id,
      'admin',
      'super_admin_001'
    ]
  );

  console.log('✅ Initial admin created');
};
