import { Router } from 'express';
import { loginDoctorController } from '../controllers/auth.controller';

const router = Router();

router.post('/doctor/login', loginDoctorController);

export default router;
