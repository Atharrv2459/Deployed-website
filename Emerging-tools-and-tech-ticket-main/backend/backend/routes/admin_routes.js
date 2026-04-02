import express from 'express';
import { addUser} from '../controllers/admin_controller.js';
import { authenticate } from '../middleware/authMiddleware.js';
import { authorizeAgentTypes, authorizeRoles } from '../middleware/roleMiddleware.js';

const router = express.Router();
router.post('/add-user', authenticate, authorizeRoles('agent'), authorizeAgentTypes('admin'), addUser);
export default router;

