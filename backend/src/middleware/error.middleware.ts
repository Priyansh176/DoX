import { NextFunction, Request, Response } from 'express';

export function notFoundHandler(_req: Request, res: Response) {
  res.status(404).json({
    success: false,
    message: 'Route not found',
  });
}

export function errorHandler(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
) {
  console.error('Unhandled error:', err.message);

  res.status(500).json({
    success: false,
    message: 'Something went wrong',
  });
}
