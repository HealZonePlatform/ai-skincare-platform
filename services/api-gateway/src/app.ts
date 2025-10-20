import crypto from 'node:crypto';
import express, { type Request, type Response } from 'express';
import cors, { type CorsOptions } from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import type { ClientRequest } from 'node:http';
import { createProxyMiddleware } from 'http-proxy-middleware';
import { config } from './config';
import { requireAuth } from './middlewares/auth';
import { errorHandler } from './middlewares/errorHandler';
import { apiLimiter } from './middlewares/rateLimiter';
import { notFound } from './middlewares/notFound';

const app = express();
const allowAnyOrigin = config.cors.allowedOrigins.includes('*');

const corsOptions: CorsOptions = {
  origin: allowAnyOrigin ? true : config.cors.allowedOrigins,
  credentials: true
};

morgan.token('request-id', req => {
  const request = req as Request & { requestId?: string };
  return request.requestId ?? '-';
});

app.disable('x-powered-by');
app.use(helmet());
app.use(cors(corsOptions));
app.use(compression());
app.use(express.json({ limit: '2mb' }));
app.use(express.urlencoded({ extended: true }));

app.use((req, res, next) => {
  const incoming = req.headers['x-request-id'];
  const requestId =
    (Array.isArray(incoming) ? incoming[0] : incoming)?.toString() ??
    crypto.randomUUID();
  req.requestId = requestId;
  res.setHeader('X-Request-Id', requestId);
  next();
});

app.use(
  morgan(
    ':remote-addr :method :url :status :res[content-length] - :response-time ms id=:request-id'
  )
);

app.use(apiLimiter);

app.get('/healthz', (_req, res) => {
  res.json({ status: 'ok' });
});

const attachProxyHeaders = (proxyReq: ClientRequest, req: Request) => {
  if (req.requestId) {
    proxyReq.setHeader('x-request-id', req.requestId);
  }
  if (req.user) {
    const { id, email, role } = req.user;
    if (typeof id === 'string') {
      proxyReq.setHeader('x-user-id', id);
    }
    if (typeof email === 'string') {
      proxyReq.setHeader('x-user-email', email);
    }
    if (typeof role === 'string') {
      proxyReq.setHeader('x-user-role', role);
    }
  }
};

const handleProxyError = (err: Error, _req: Request, res: Response) => {
  if (!res.headersSent) {
    res.status(502).json({ error: 'Upstream service unavailable' });
  }
  if (config.nodeEnv !== 'production') {
    console.error('[api-gateway] proxy error:', err);
  }
};

const silentInfo = () => undefined;
const proxyLogger =
  config.nodeEnv === 'development'
    ? console
    : {
        info: silentInfo,
        warn: console.warn.bind(console),
        error: console.error.bind(console)
      };

const createServiceProxy = (prefix: string, target: string) =>
  createProxyMiddleware<Request, Response>({
    target,
    changeOrigin: true,
    pathRewrite: { [`^${prefix}`]: '/' },
    proxyTimeout: config.proxy.timeout,
    timeout: config.proxy.timeout,
    logger: proxyLogger,
    on: {
      proxyReq: attachProxyHeaders,
      error: (err, req, res) => handleProxyError(err, req as Request, res as Response)
    }
  });

app.use('/api/v1/auth', createServiceProxy('/api/v1/auth', config.services.auth));

app.use(requireAuth);

const protectedRoutes: Array<[string, string]> = [
  ['/api/v1/me', config.services.user],
  ['/api/v1/products', config.services.product],
  ['/api/v1/experts', config.services.expert],
  ['/api/v1/recommend', config.services.recommendation],
  ['/api/v1/analysis', config.services.ai]
];

protectedRoutes.forEach(([prefix, target]) => {
  app.use(prefix, createServiceProxy(prefix, target));
});

app.use(notFound);
app.use(errorHandler);

export default app;
