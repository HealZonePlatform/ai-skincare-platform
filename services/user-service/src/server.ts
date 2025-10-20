import http from 'http';
import app from './app';
import { env } from './config/env';
import { healthCheck } from './config/database';

const server = http.createServer(app);
const PORT = Number(env.PORT || 3004);

server.listen(PORT, async () => {
  const ok = await healthCheck();
  console.log(`[user-service v2] listening on :${PORT} (db: ${ok ? 'ok' : 'failed'})`);
});

const shutdown = (sig: string) => () => {
  console.log(`[user-service v2] received ${sig}, shutting down...`);
  server.close(() => {
    console.log('[user-service v2] closed');
    process.exit(0);
  });
  setTimeout(() => process.exit(1), 10000).unref();
};
process.on('SIGTERM', shutdown('SIGTERM'));
process.on('SIGINT', shutdown('SIGINT'));
