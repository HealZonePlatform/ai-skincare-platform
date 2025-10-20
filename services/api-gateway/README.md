## HealZone API Gateway

- Express gateway that fronts the HealZone microservices and proxies traffic to downstream services.
- Reverse proxy via `http-proxy-middleware` with forwarded `x-request-id` and `x-user-*` headers.
- Secure defaults: Helmet, compression, configurable CORS, and rate limiting.
- JWT verification uses the shared `hz-shared` library to stay consistent with other services.
- Environment configuration is parsed with `zod` to fail fast on misconfiguration.

```
api-gateway/
├── src/
│   ├── app.ts              # Express app, proxy setup
│   ├── server.ts           # Boots the HTTP server
│   ├── config/index.ts     # Env loading + derived config
│   ├── middlewares/
│   │   ├── auth.ts         # JWT guard (hz-shared)
│   │   ├── errorHandler.ts # Normalised error responses
│   │   ├── notFound.ts     # 404 helper
│   │   └── rateLimiter.ts  # Config-driven rate limiting
│   └── types/express.d.ts  # Extends Express Request typings
├── .env.example            # Sample environment variables
├── Dockerfile              # Multi-stage build configuration
├── package.json            # Dependencies & scripts
└── tsconfig.json           # TypeScript settings
```

**Proxy Map**
- `/healthz` → health probe (no upstream)
- `/api/v1/auth/*` → `${AUTH_SERVICE_URL}`
- `/api/v1/me/*` → `${USER_SERVICE_URL}`
- `/api/v1/products/*` → `${PRODUCT_SERVICE_URL}`
- `/api/v1/experts/*` → `${EXPERT_SERVICE_URL}`
- `/api/v1/recommend/*` → `${RECOMMENDATION_SERVICE_URL}`
- `/api/v1/analysis/*` → `${AI_SERVICE_URL}`

Routes after `/api/v1/auth/*` require a valid `Authorization: Bearer <token>` signed with `JWT_ACCESS_SECRET`.

**Environment**

Copy `.env.example` to `.env` and adjust:
- `PORT`, `NODE_ENV`
- `JWT_ACCESS_SECRET`
- `ALLOWED_ORIGINS`
- `RATE_LIMIT_WINDOW_MS`, `RATE_LIMIT_MAX`
- `PROXY_TIMEOUT_MS`
- Downstream service URLs (`*_SERVICE_URL`)

**Development**

```bash
npm install
npm run dev
```

The gateway listens on `http://localhost:3000`.

**Production build**

```bash
npm run build
npm start
```

**Docker**

```bash
docker build -t healzone-api-gateway .
docker run --rm -p 3000:3000 --env-file .env healzone-api-gateway
```
