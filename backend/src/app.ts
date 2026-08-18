import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { env } from './config/env';
import { errorHandler, notFoundHandler } from './middleware/error.middleware';
import authRoutes from './routes/auth.routes';
import doctorRoutes from './routes/doctor.routes';
import clinicRoutes from './routes/clinic.routes';
import tokenRoutes from './routes/token.routes';

export const app = express();

app.use(
  cors({
    origin: env.clientUrl,
    credentials: true,
  }),
);

app.use(helmet());
app.use(express.json());

app.get('/api/health', (_req, res) => {
  res.json({
    success: true,
    message: 'Clinic token backend is running',
  });
});

app.use('/api/auth', authRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/clinics', clinicRoutes);
app.use('/api/tokens', tokenRoutes);

app.use(notFoundHandler);
app.use(errorHandler);
