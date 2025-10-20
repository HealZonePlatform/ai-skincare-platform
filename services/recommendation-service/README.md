## HealZone Recommendation Service

- FastAPI microservice that produces personalised skincare recommendations.
- Integrates with product-service and (optionally) AI analysis outputs to rank products.
- Uses shared `httpx.AsyncClient` with connection pooling and configurable timeouts.
- Pydantic models guard request/response payloads and provide documentation metadata.
- Environment-driven configuration (see `.env.example`) with sensible defaults for docker-compose.

```
recommendation-service/
├── app/
│   ├── __init__.py
│   ├── config.py
│   ├── main.py
│   ├── schemas.py
│   └── services/
│       ├── __init__.py
│       └── recommendation.py
├── requirements.txt
├── Dockerfile
└── .env.example
```

**API**
- `GET /healthz` – liveness probe.
- `POST /recommend` – accepts `RecommendationRequest` and returns `RecommendationResponse`.

**Configuration**
- `PRODUCT_SERVICE_URL` – defaults to `http://product-service:3003`.
- `AI_SERVICE_URL` – defaults to `http://ai-service:3006`.
- `RECOMMENDATION_LIMIT` – default number of items when the request omits `limit`.
- `HTTP_TIMEOUT_SECONDS` – outbound HTTP timeout for downstream calls.

**Local development**
```bash
python -m venv .venv && source .venv/bin/activate  # or use your preferred virtualenv workflow
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 3005
```

**Docker**
```bash
docker build -t healzone-recommendation-service .
docker run --rm -p 3005:3005 --env-file .env healzone-recommendation-service
```
