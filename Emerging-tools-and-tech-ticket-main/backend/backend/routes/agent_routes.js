import express from 'express';


import { authenticate } from '../middleware/authMiddleware.js';
import { authorizeAgentTypes, authorizeRoles } from '../middleware/roleMiddleware.js';
import { closeTicket, escalateToAdmin, getUnassignedTickets, myAssignedTickets, pickTicket,  agentTickets, agentUpdateTicket, getTicketById, getTicketComments, agentAddComment} from '../controllers/agent_controller.js';

const router = express.Router();

/*/router.get( '/open-tickets', authenticate, authorizeRoles('agent'), openTickets);/*/
router.get('/unassigned-tickets', authenticate, authorizeRoles('agent'), getUnassignedTickets);
router.post( '/pick/:ticketId', authenticate, authorizeRoles('agent'), pickTicket);
router.get( '/my-tickets', authenticate, authorizeRoles('agent'), myAssignedTickets);
router.post('/ticket/:ticketId/escalate', authenticate, authorizeRoles('agent'), authorizeAgentTypes('normal'), escalateToAdmin);
router.patch('/ticket/:ticketId/close', authenticate, authorizeRoles('agent'), closeTicket);
router.get('/tickets', authenticate, authorizeRoles('agent'),agentTickets);
router.get('/ticket/:ticketId',authenticate, authorizeRoles('agent'), getTicketById);
router.patch('/tickets/:ticketId',authenticate, authorizeRoles('agent'), agentUpdateTicket);
router.get('/tickets/:ticketId/view-comments',authenticate,authorizeRoles('agent'), getTicketComments);
router.post('/tickets/:ticketId/agent-comment', authenticate, authorizeRoles('agent'), authorizeAgentTypes('normal'), agentAddComment);

export default router;