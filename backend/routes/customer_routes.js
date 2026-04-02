import express from 'express';
import { addComment, createTicket, getMyProfile, getTicketComments, myTickets } from '../controllers/customer_controller.js';
import { authenticate } from '../middleware/authMiddleware.js';
import { authorizeRoles } from '../middleware/roleMiddleware.js';

const router = express.Router();

router.get('/tickets',authenticate,authorizeRoles('customer', 'agent'), myTickets);
router.post('/ticket',authenticate,authorizeRoles('customer', 'manager', 'agent'),createTicket);
router.post('/ticket/:ticketId/comment', authenticate,authorizeRoles('customer', 'agent'),  addComment);
router.get('/ticket/:ticketId/comments', authenticate, authorizeRoles('customer', 'agent'), getTicketComments);
router.get('/profile', authenticate, getMyProfile);
export default router;