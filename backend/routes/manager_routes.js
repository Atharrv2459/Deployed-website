import express from 'express';
import { approveOrRejectTicket, getApprovedTicketsForManager, getCustomersUnderManager, getPendingTicketsForApproval, getRejectedTicketsForManager, rejectTicketWithReason } from "../controllers/manager_controller.js";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorizeCustomerTypes, authorizeRoles } from '../middleware/roleMiddleware.js';

const router = express.Router();
router.get('/pending-tickets',authenticate,  authorizeRoles('customer'),getPendingTicketsForApproval);
router.patch('/ticket/:ticketId/update', authenticate, authorizeRoles('customer'),approveOrRejectTicket);
router.get('/customers', authenticate, authorizeRoles('customer'), authorizeCustomerTypes('manager'), getCustomersUnderManager);
router.patch('/ticket/:ticketId/reject',authenticate,authorizeRoles('customer'),rejectTicketWithReason);
router.get('/tickets/approved',authenticate,authorizeRoles('customer'),authorizeCustomerTypes('manager'), getApprovedTicketsForManager);
router.get('/tickets/rejected',authenticate,authorizeRoles('customer'),authorizeCustomerTypes('manager'),getRejectedTicketsForManager);

export default router;