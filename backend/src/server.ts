import { createServer } from 'http';
import { app } from './app';
import { env } from './config/env';
import { testDatabaseConnection } from './config/database';
import { initializeSocketServer } from './sockets/queue.socket';

async function startServer() {
  try {
    await testDatabaseConnection();
    const server = createServer(app);
    initializeSocketServer(server);

    server.listen(env.port, "0.0.0.0", () => {
      console.log(`Server running on port ${env.port}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
