import mysql from 'mysql2/promise';
import { env } from '../config/env';

export const db = mysql.createPool(env.databaseUrl);

export async function query<T = any>(sql: string, values: any[] = []) {
  const [rows] = await db.execute<T & mysql.RowDataPacket[]>(sql, values);
  return rows as T[];
}

export async function queryOne<T = any>(sql: string, values: any[] = []) {
  const [rows] = await db.execute<T & mysql.RowDataPacket[]>(sql, values);
  return (rows as T[])[0] || null;
}
