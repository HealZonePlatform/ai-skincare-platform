import express, { Request, Response, NextFunction } from 'express';
import 'express-async-errors';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import createHttpError from 'http-errors';
import expertRoutes from './routes/expert.routes';
import { connectDB } from './config/database';

void connectDB();

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(
  morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev')
);

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.use('/api/v1/experts', expertRoutes);

app.use((req, _res, next) => {
  next(
    new createHttpError.NotFound(
      `Route ${req.method} ${req.originalUrl} not found`
    )
  );
});

// eslint-disable-next-line @typescript-eslint/no-unused-vars
app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
  const status = err.status ?? 500;
  const message = err.message ?? 'Internal server error';

  res.status(status).json({
    message,
    ...(process.env.NODE_ENV !== 'production' && { stack: err.stack })
  });
});

export default app;
