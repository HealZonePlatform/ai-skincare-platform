export class ApiError extends Error {
  status: number;
  constructor(status: number, message: string) {
    super(message);
    this.status = status;
  }
}

export const notFound = () => new ApiError(404, 'Not Found');
export const unauthorized = () => new ApiError(401, 'Unauthorized');
export const forbidden = () => new ApiError(403, 'Forbidden');
