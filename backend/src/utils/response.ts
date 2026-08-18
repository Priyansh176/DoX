export function successResponse(data: any = {}, message?: string) {
  return {
    success: true,
    ...(message ? { message } : {}),
    data,
  };
}

export function errorResponse(message: string, errors?: Record<string, any>) {
  return {
    success: false,
    message,
    ...(errors ? { errors } : {}),
  };
}
