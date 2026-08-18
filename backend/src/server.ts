import { createServer } from 'http';
import { app } from './app';
import { env } from './config/env';
import { testDatabaseConnection } from './config/database';
import { setupSocket } from './sockets/queue.socket';

async function startServer() {
  try {
    await testDatabaseConnection();
    const server = createServer(app);
    setupSocket(server);

    server.listen(env.port, () => {
      console.log(`Server running on port ${env.port}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
