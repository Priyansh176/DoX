import mysql from 'mysql2/promise';
import { env } from './env';

export const pool = mysql.createPool({
  uri: env.databaseUrl,
  waitForConnections: true,
  connectionLimit: 10,
  maxIdle: 5,
  idleTimeout: 60000,
  queueLimit: 0,
});

export async function testDatabaseConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('Database connected successfully');
    connection.release();
  } catch (error) {
    console.error('Database connection failed:', error);
    throw error;
  }
}
