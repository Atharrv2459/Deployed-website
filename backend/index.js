import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import cors from 'cors';
import { testDbConnection } from './config/db.js';
import adminRoutes from './routes/admin_routes.js';
import authRoutes from './routes/auth_routes.js';
import { bootstrapAdmin } from './config/bootstrapAdmin.js';
import customerRoutes from './routes/customer_routes.js';
import managerRoutes from './routes/manager_routes.js';
import agentRoutes from './routes/agent_routes.js';
import ticketRoutes from './routes/ticket_routes.js';


const app = express();

app.use(cors());
app.use(express.json());

await testDbConnection();

// Health check endpoint for Render
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/customer', customerRoutes);
app.use('/api/manager', managerRoutes);
app.use('/api/agent', agentRoutes);
app.use('/api/ticket', ticketRoutes);




const PORT = process.env.PORT || 5000;
app.listen(PORT, () =>
  console.log(`Server running on port ${PORT}`)
);
