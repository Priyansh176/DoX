import dotenv from 'dotenv';

dotenv.config();

const dbHost = process.env.DB_HOST || 'localhost';
const dbPort = Number(process.env.DB_PORT || 3306);
const dbUser = process.env.DB_USER || 'root';
const dbPassword = process.env.DB_PASSWORD || 'mysql@2006';
const dbName = process.env.DB_NAME || 'hospital_clinic';

const generatedDatabaseUrl = `mysql://${dbUser}:${encodeURIComponent(dbPassword)}@${dbHost}:${dbPort}/${dbName}`;

export const env = {
  port: Number(process.env.PORT || 5000),
  jwtSecret: process.env.JWT_SECRET || 'development_secret',
  dbHost,
  dbPort,
  dbUser,
  dbPassword,
  dbName,
  databaseUrl: process.env.DATABASE_URL || generatedDatabaseUrl,
  clientUrl: process.env.CLIENT_URL || 'http://localhost:5173',
  socketCorsOrigin: process.env.SOCKET_CORS_ORIGIN || 'http://localhost:5173',
};
