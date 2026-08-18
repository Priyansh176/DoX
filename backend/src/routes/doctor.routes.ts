import { Router } from 'express';
import { getDoctorProfile, getDoctorQueue, advanceDoctorQueue, getDoctorStatus, updateDoctorStatus } from '../controllers/doctor.controller';
import { requireDoctorAuth } from '../middleware/auth.middleware';

const router = Router();

router.use(requireDoctorAuth);

router.get('/me', getDoctorProfile);
router.get('/me/queue', getDoctorQueue);
router.post('/me/queue/next', advanceDoctorQueue);
router.get('/me/status', getDoctorStatus);
router.patch('/me/status', updateDoctorStatus);

export default router;
