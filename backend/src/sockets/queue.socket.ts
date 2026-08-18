import { Server } from 'socket.io';

export function setupSocket(server: any) {
  const io = new Server(server, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST'],
    },
  });

  io.on('connection', (socket) => {
    console.log('Socket connected:', socket.id);

    socket.on('join-doctor-room', (doctorId: number) => {
      socket.join(`doctor:${doctorId}`);
      console.log(`Socket ${socket.id} joined doctor room ${doctorId}`);
    });

    socket.on('disconnect', () => {
      console.log('Socket disconnected:', socket.id);
    });
  });

  return io;
}
