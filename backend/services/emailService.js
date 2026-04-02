import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: false,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  }
});


const getAgentTypeLabel = (agent_type) => {
  if (!agent_type) return null;

  switch (agent_type) {
    case 'normal':
      return 'Consultant';
    case 'delivery_lead':
      return 'Delivery Lead';
    case 'hod':
      return 'HOD';
    case 'admin':
      return 'Admin';
    default:
      return agent_type;
  }
};

export const sendUserCredentialsEmail = async ({
  to,
  name,
  email,
  role,
  agent_type,
  customer_type,
  account_name,
  tempPassword,
  manager_email,
  delivery_lead_email
}) => {

 
  const html = `
    <h3>Welcome to Ticket Management System</h3>

    <p><strong>Name:</strong> ${name}</p>
    <p><strong>Email:</strong> ${email}</p>
    <p><strong>Role:</strong> ${role}</p>

    ${agent_type ? `<p><strong>Agent Type:</strong> ${getAgentTypeLabel(agent_type)}</p>` : ''}
    ${customer_type ? `<p><strong>Customer Type:</strong> ${customer_type}</p>` : ''}

    ${manager_email ? `<p><strong>Customer Manager:</strong> ${manager_email}</p>` : ''}
    ${delivery_lead_email ? `<p><strong>Delivery Lead:</strong> ${delivery_lead_email}</p>` : ''}

    <p><strong>Account Name:</strong> ${account_name}</p>

    <hr/>
    <p><strong>Temporary Password:</strong> ${tempPassword}</p>

    <p>Please login and change your password immediately.</p>
  `;

  const response = await transporter.sendMail({
    from: `"Support Team" <${process.env.SMTP_USER}>`,
    to,
    subject: 'Your Account Credentials',
    html
  });

  console.log('Email sent response:', response);
};

export const sendTicketRaisedEmail = async ({ to, ticket }) => {
  const html = `
    <h3>Ticket Created Successfully</h3>
    <p>Your ticket has been submitted.</p>
    <p><strong>Ticket ID:</strong> ${ticket.id}</p>
    <p><strong>Subject:</strong> ${ticket.subject}</p>
    <p><strong>Category:</strong> ${ticket.category}</p>
    <p><strong>Priority:</strong> ${ticket.priority}</p>
    <p><strong>Status:</strong> ${ticket.status}</p>
    <p>You will be notified when there are updates.</p>
  `;

  await transporter.sendMail({
    from: `"Support Team" <${process.env.SMTP_USER}>`,
    to,
    subject: `Ticket #${ticket.id} Created - ${ticket.subject}`,
    html
  });
};

export const sendTicketRaisedToManagerEmail = async ({ to, ticket, customer }) => {
  const html = `
    <h3>New Ticket Pending Approval</h3>
    <p>A new ticket has been raised by a customer under your management.</p>
    <hr/>
    <p><strong>Customer Name:</strong> ${customer.name}</p>
    <p><strong>Customer Email:</strong> ${customer.email}</p>
    <hr/>
    <p><strong>Ticket ID:</strong> ${ticket.id}</p>
    <p><strong>Subject:</strong> ${ticket.subject}</p>
    <p><strong>Category:</strong> ${ticket.category}</p>
    <p><strong>Priority:</strong> ${ticket.priority}</p>
    <p>Please login to approve or reject this ticket.</p>
  `;

  await transporter.sendMail({
    from: `"Support Team" <${process.env.SMTP_USER}>`,
    to,
    subject: `Ticket #${ticket.id} Pending Approval - ${ticket.subject}`,
    html
  });
};


export const sendCustomerCommentEmail = async ({
  to,
  ticketId,
  subject,
  comment,
  recipientType
}) => {
  const html = `
    <h3>New Comment on Ticket</h3>

    <p>A new comment has been added by the <strong>Customer</strong>.</p>

    <p><strong>Ticket ID:</strong> ${ticketId}</p>

    ${subject ? `<p><strong>Comment Subject:</strong> ${subject}</p>` : ''}

    <p><strong>Comment:</strong></p>
    <p>${comment}</p>

    <br/>
    <p>Please login to review the update.</p>
  `;

  await transporter.sendMail({
    from: `"Ticket System" <${process.env.SMTP_USER}>`,
    to,
    subject: `New Comment on Ticket #${ticketId}`,
    html
  });
};

export const sendTicketApprovedEmail = async ({ toEmails, ticket }) => {
  if (!toEmails.length) return;

  const html = `
    <h3>New Ticket Approved</h3>
    <p>A new ticket has been approved by the manager.</p>
    <p><strong>Ticket ID:</strong> ${ticket.id}</p>
    <p><strong>Title:</strong> ${ticket.title}</p>
    <p><strong>Description:</strong> ${ticket.description}</p>
    <p><strong>Status:</strong> ${ticket.status}</p>
    <br/>
    <p>Please login to the system to accept or assign this ticket.</p>
  `;

  await transporter.sendMail({
    from: `"Ticket System" <${process.env.SMTP_USER}>`,
    to: toEmails.join(','),
    subject: `Ticket #${ticket.id} Approved`,
    html
  });
};

// ------------------- mail send to customer when ticket is rejected -------------------
export const sendTicketRejectedEmail = async ({ to, ticket }) => {
  const html = `
    <h3>Your Ticket Has Been Rejected</h3>

    <p><strong>Ticket ID:</strong> ${ticket.id}</p>
    <p><strong>Subject:</strong> ${ticket.subject}</p>

    <p><strong>Reason for Rejection:</strong></p>
    <p>${ticket.rejection_reason}</p>

    <br/>
    <p>If you have questions, please contact support.</p>
  `;

  await transporter.sendMail({
    from: `"Ticket System" <${process.env.SMTP_USER}>`,
    to,
    subject: `Ticket #${ticket.id} Rejected`,
    html
  });
};


// ------------------- mail send to admin when ticket status is updated -------------------

export const sendTicketStatusUpdateEmail = async ({ to, ticket }) => {
  const html = `
    <h3>Ticket Status Updated</h3>

    <p>The status of a ticket has been updated.</p>

    <p><strong>Ticket ID:</strong> ${ticket.id}</p>
    <p><strong>Subject:</strong> ${ticket.subject}</p>
    <p><strong>Old Status:</strong> ${ticket.old_status}</p>
    <p><strong>New Status:</strong> ${ticket.new_status}</p>

    <br/>
    <p>Please login to track the progress.</p>
  `;

  await transporter.sendMail({
    from: `"Ticket System" <${process.env.SMTP_USER}>`,
    to,
    subject: `Ticket #${ticket.id} Status Updated`,
    html
  });
};

export const sendAgentCommentEmail = async ({
  to,
  ticketId,
  subject,
  comment,
  recipientType
}) => {
  const html = `
    <h3>New Comment on Ticket</h3>

    <p>A new comment has been added by the <strong>Agent</strong>.</p>

    <p><strong>Ticket ID:</strong> ${ticketId}</p>

    ${subject ? `<p><strong>Comment Subject:</strong> ${subject}</p>` : ''}

    <p><strong>Comment:</strong></p>
    <p>${comment}</p>

    <br/>
    <p>Please login to view the ticket for more details.</p>
  `;

  await transporter.sendMail({
    from: `"Ticket System" <${process.env.SMTP_USER}>`,
    to,
    subject: `New Comment on Ticket #${ticketId}`,
    html
  });
};
