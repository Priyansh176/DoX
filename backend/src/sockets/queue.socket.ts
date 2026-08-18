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

export function emitDoctorQueueUpdate(doctorId: number, payload: any) {
  const io = (globalThis as any).__doctorSocketServer;
  if (io) {
    io.to(`doctor:${doctorId}`).emit('queue-updated', payload);
  }
}

export function emitDoctorStatusUpdate(doctorId: number, payload: any) {
  const io = (globalThis as any).__doctorSocketServer;
  if (io) {
    io.to(`doctor:${doctorId}`).emit('doctor-status-changed', payload);
  }
}

export function initializeSocketServer(server: any) {
  const io = setupSocket(server);
  (globalThis as any).__doctorSocketServer = io;
  return io;
}
