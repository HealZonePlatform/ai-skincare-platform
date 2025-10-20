import http from 'node:http';
import app from './app';
import { config } from './config';

const server = http.createServer(app);

server.listen(config.port, () => {
  console.log(`[api-gateway] listening on port ${config.port}`);
});

const shutdown = (signal: NodeJS.Signals) => {
  console.log(`[api-gateway] received ${signal}, shutting down...`);
  server.close(() => {
    console.log('[api-gateway] server closed');
    process.exit(0);
  });
  setTimeout(() => {
    console.error('[api-gateway] shutdown timed out, forcing exit');
    process.exit(1);
  }, 10_000).unref();
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

process.on('unhandledRejection', err => {
  console.error('[api-gateway] unhandled rejection', err);
});

process.on('uncaughtException', err => {
  console.error('[api-gateway] uncaught exception', err);
  shutdown('SIGTERM');
});
