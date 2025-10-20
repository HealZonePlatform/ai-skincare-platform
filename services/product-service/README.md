# HealZone Product Service

REST API that powers HealZone's product catalogue. Built with Express, TypeScript and MongoDB.

## Getting started

```bash
cp .env.example .env # adjust values if you keep an example file
npm install
npm run dev
```

Environment variables:

- `MONGODB_URI` (required) connection string to MongoDB.
- `PORT` (optional) defaults to `3003`.
- `MONGODB_MAX_POOL_SIZE` (optional) limits concurrent connections, defaults to `10`.
- `MONGODB_DEBUG` (optional) set to `true` to log Mongo queries.

## Scripts

- `npm run dev` – start the dev server with live reload.
- `npm run build` – transpile TypeScript into `dist/`.
- `npm start` – launch the compiled server.

## API

Base path: `/api/v1/products`

| Method | Path               | Description |
| ------ | ------------------ | ----------- |
| GET    | `/`                | List products with filters and pagination. |
| GET    | `/:id`             | Retrieve a single product. |
| POST   | `/`                | Create a product (requires authentication middleware in gateway). |
| PUT    | `/:id`             | Update a product. |
| DELETE | `/:id`             | Remove a product. |
| GET    | `/categories`      | Retrieve distinct category/sub-category pairs. |

### Filtering & pagination

`GET /api/v1/products` supports the following query parameters:

- `skinType` – exact match for available skin types.
- `concerns` – comma separated list of concerns to match (`acne,dryness`).
- `category` / `subCategory` – filter by taxonomy.
- `verified`, `isActive`, `isRecommended` – boolean flags (`true`/`false`).
- `tags` – comma separated list of tags.
- `minPrice`, `maxPrice` – numeric boundaries (USD / VND etc. depending on product record).
- `search` – full-text search against indexed fields.
- `limit` / `offset` – pagination (limit capped at 100).
- `sort` – comma separated fields (`-createdAt,+price.amount,ratings.average`).

The response contains a `data` array and a `pagination` object with `total`, `limit` and `offset`.

### Health check

`GET /health` returns `{ "status": "ok" }` when the service is ready.

## Docker

Build and run the container:

```bash
docker build -t healzone-product-service .
docker run -p 3003:3003 --env MONGODB_URI=<mongodb-uri> healzone-product-service
```
