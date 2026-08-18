import { Router } from 'express';
import { clinics } from '../data/store';
import { successResponse } from '../utils/response';

const router = Router();

router.get('/', (_req, res) => {
  res.json(successResponse({ clinics }));
});

export default router;
