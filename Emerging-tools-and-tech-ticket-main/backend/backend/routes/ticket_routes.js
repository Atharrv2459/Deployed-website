import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { authorizeRoles } from '../middleware/roleMiddleware.js';
import { deleteTicket, getTicketDetails, updateTicket, updateTicketStatus} from '../controllers/ticket_controller.js';


const router = express.Router();
router.get( '/ticket/:ticketId', authenticate, authorizeRoles('customer', 'agent'), getTicketDetails);
// router.post('/create-ticket',authenticate,authorizeRoles('customer', 'manager', 'agent', 'delivery_lead'),uploadToS3,uploadFilesToS3,createTicket);

router.delete('/ticket/:ticketId', authenticate, authorizeRoles('customer', 'agent'), deleteTicket);
router.patch('/ticket/:ticketId', authenticate, authorizeRoles('customer', 'agent'), updateTicket);
router.patch('/ticket/:ticketId/status',authenticate, authorizeRoles('agent', 'customer'), updateTicketStatus);
export default router;

