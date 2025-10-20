# HealZone Expert Service

Manages HealZone's expert directory, including profiles, availability, consultation options, and community reviews. Built with Express, TypeScript, and MongoDB.

## Getting started

```bash
npm install
npm run dev
```

Environment variables:

- `MONGODB_URI` – MongoDB connection string (defaults to `mongodb://127.0.0.1:27017/healzone-experts`).
- `PORT` – HTTP port (defaults to `3002`).
- `MONGODB_MAX_POOL_SIZE` – Optional connection pool size (defaults to `10`).
- `MONGODB_DEBUG` – Set to `true` to log MongoDB queries.

## Scripts

- `npm run dev` – start development server with live reload.
- `npm run build` – compile TypeScript into `dist/`.
- `npm start` – run the compiled build.

## API

Base path: `/api/v1/experts`

| Method | Path | Description |
| ------ | ---- | ----------- |
| GET | `/` | List experts with filters, pagination, and sorting. |
| POST | `/` | Create a new expert profile (apply auth/role guard in gateway). |
| GET | `/:id` | Retrieve an expert by id. |
| PUT | `/:id` | Update an expert profile. |
| DELETE | `/:id` | Remove an expert profile. |
| GET | `/specialties` | Aggregate available specialties and counts. |
| GET | `/:id/reviews` | Fetch reviews for a specific expert. |
| POST | `/:id/reviews` | Submit a review and recalculate expert rating. |
| DELETE | `/:id/reviews/:reviewId` | Remove a specific review. |

### Query parameters

`GET /api/v1/experts` accepts:

- `specialty` – comma-separated list to match (`dermatology,acne`).
- `language` – comma-separated preferred languages.
- `verified` – `true/false` flag.
- `tags` – comma-separated tags.
- `minExperience` – minimum years of experience.
- `search` – full-text search over name/about/specialties.
- `latitude`, `longitude`, `radiusKm` – optional geo-search using stored coordinates.
- `limit` / `offset` – pagination (limit capped at 100).
- `sort` – comma-separated sort keys, prefix with `-` for descending (e.g. `-rating.average,yearsOfExperience`).

Responses return `{ data, pagination }` with pagination metadata.

### Health check

`GET /health` reports `{ "status": "ok" }` when the service is ready.

## Docker

```bash
docker build -t healzone-expert-service .
docker run -p 3002:3002 --env MONGODB_URI=<mongodb-uri> healzone-expert-service
```
