import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { env } from './config/env';
import meRoutes from './routes/me.routes';
import { notFound, errorHandler } from './middlewares/error';

const app = express();
const origins = env.ALLOWED_ORIGINS?.split(',').map(s => s.trim()) || ['*'];

app.use(helmet());
app.use(cors({ origin: origins, credentials: true }));
app.use(express.json({ limit: '2mb' }));
app.use(morgan('dev'));

app.use('/api/v1/me', meRoutes);

app.get('/health', (_req, res) => res.json({ status: 'ok' }));
app.use(notFound);
app.use(errorHandler);

export default app;
