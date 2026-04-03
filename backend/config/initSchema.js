import pool from './db.js';

export const initSchema = async () => {
  // Check if tables exist
  const tablesExist = await pool.query(`
    SELECT EXISTS (
      SELECT FROM information_schema.tables 
      WHERE table_schema = 'public' AND table_name = 'users'
    );
  `);

  if (tablesExist.rows[0].exists) {
    console.log('✅ Database schema already exists');
    return;
  }

  console.log('🔄 Creating database schema...');

  await pool.query(`
    -- Roles table
    CREATE TABLE IF NOT EXISTS roles (
      id SERIAL PRIMARY KEY,
      role_name VARCHAR(20) NOT NULL UNIQUE
    );

    -- Insert default roles
    INSERT INTO roles (role_name) VALUES ('agent'), ('customer'), ('manager')
    ON CONFLICT (role_name) DO NOTHING;

    -- Customers table
    CREATE TABLE IF NOT EXISTS customers (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      customer_code VARCHAR(50),
      company_name VARCHAR(255) NOT NULL,
      industry_type VARCHAR(100),
      contact_name VARCHAR(255),
      contact_email VARCHAR(255),
      contact_phone VARCHAR(50),
      address TEXT,
      city VARCHAR(100),
      state VARCHAR(100),
      country VARCHAR(100),
      timezone VARCHAR(50),
      status VARCHAR(20) DEFAULT 'ACTIVE',
      created_at TIMESTAMP DEFAULT NOW(),
      created_by UUID
    );

    -- Users table
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      role_id INTEGER NOT NULL REFERENCES roles(id),
      phone VARCHAR(20),
      department VARCHAR(50),
      organization VARCHAR(100),
      associated_account VARCHAR(100),
      is_active BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      account_name VARCHAR(100),
      agent_type VARCHAR(20) CHECK (agent_type IN ('normal', 'delivery_lead', 'admin', 'hod')),
      delivery_lead_id INTEGER,
      customer_type VARCHAR(20),
      manager_id INTEGER,
      user_type VARCHAR(20),
      customer_id UUID REFERENCES customers(id)
    );

    -- Tickets table
    CREATE TABLE IF NOT EXISTS tickets (
      id SERIAL PRIMARY KEY,
      requester VARCHAR(100) NOT NULL,
      contact_email VARCHAR(100),
      contact_phone VARCHAR(20),
      subject VARCHAR(200) NOT NULL,
      description TEXT,
      category VARCHAR(50) NOT NULL CHECK (category IN ('SAP', 'Product', 'Integration', 'Other')),
      status VARCHAR(30) DEFAULT 'Open' CHECK (status IN ('Unassigned', 'Open', 'Assigned', 'Requirements', 'Development', 'Internal Testing', 'UAT', 'Resolved', 'Closed')),
      priority VARCHAR(20),
      assignee_id INTEGER REFERENCES users(id),
      account_name VARCHAR(100),
      due_date DATE,
      sla_hours INTEGER NOT NULL,
      resolution TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      escalated_to INTEGER REFERENCES users(id),
      escalation_reason TEXT,
      delivery_lead_id INTEGER REFERENCES users(id),
      approval_status VARCHAR(20) DEFAULT 'Pending',
      approved_by INTEGER REFERENCES users(id),
      approved_at TIMESTAMP,
      assigned_by INTEGER REFERENCES users(id),
      assigned_at TIMESTAMP,
      rejection_reason TEXT,
      sub_category VARCHAR(100) NOT NULL,
      type VARCHAR(30) NOT NULL CHECK (type IN ('Incident', 'Query', 'Problem', 'Change')),
      environment VARCHAR(20) NOT NULL CHECK (environment IN ('QA', 'PRD')),
      rca TEXT,
      comment TEXT,
      waiting_for_customer BOOLEAN DEFAULT FALSE,
      requester_id INTEGER REFERENCES users(id),
      customer_id UUID REFERENCES customers(id),
      created_for INTEGER REFERENCES users(id)
    );

    -- Ticket Comments table
    CREATE TABLE IF NOT EXISTS ticket_comments (
      id SERIAL PRIMARY KEY,
      ticket_id INTEGER NOT NULL REFERENCES tickets(id),
      commented_by INTEGER NOT NULL REFERENCES users(id),
      comment_subject VARCHAR(255),
      comment_text TEXT NOT NULL,
      commented_role VARCHAR(20) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Ticket Attachments table
    CREATE TABLE IF NOT EXISTS ticket_attachments (
      id SERIAL PRIMARY KEY,
      ticket_id INTEGER REFERENCES tickets(id),
      file_name VARCHAR(255),
      file_type VARCHAR(50),
      file_path TEXT,
      uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      uploaded_by INTEGER REFERENCES users(id)
    );

    -- Ticket Status Logs table
    CREATE TABLE IF NOT EXISTS ticket_status_logs (
      id SERIAL PRIMARY KEY,
      ticket_id INTEGER NOT NULL REFERENCES tickets(id),
      old_status VARCHAR(30),
      new_status VARCHAR(30) NOT NULL,
      changed_by INTEGER NOT NULL REFERENCES users(id),
      changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    -- Notifications table
    CREATE TABLE IF NOT EXISTS notifications (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL REFERENCES users(id),
      title TEXT NOT NULL,
      message TEXT NOT NULL,
      is_read BOOLEAN DEFAULT FALSE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `);

  console.log('✅ Database schema created successfully');
};
