## HealZone AI Service

- FastAPI microservice that generates structured skin analysis reports using Google Gemini.
- Accepts uploaded images (base64 or URL) plus optional context and returns schema-validated JSON with MIME/size validation.
- Persists analyses in PostgreSQL (`skin_analyses` table) with query filters over severity/model/date.
- Verifies user existence via shared database before processing analyses to maintain cross-service data integrity.
- Supports multi-model selection, trend reporting, retention policies, and webhook notifications for downstream services.
- Adds retry/backoff and a configurable in-memory cache to reduce repeated Gemini calls.
- Limits concurrent analyses to protect upstream quotas and logs feedback for continual improvement.

```
ai-service/
|- app/
|  |- __init__.py
|  |- config.py
|  |- db.py
|  |- main.py
|  |- repositories/
|  |  |- __init__.py
|  |  |- analysis.py
|  |- schemas.py
|  |- services/
|     |- __init__.py
|     |- analysis.py
|     |- cache.py
|- requirements.txt
|- Dockerfile
|- .env.example
```

**Environment**

Copy `.env.example` to `.env` and fill in:

- `GOOGLE_AI_STUDIO_API_KEY` – API key from [Google AI Studio](https://aistudio.google.com/).
- `GEMINI_MODEL_NAME` – defaults to `gemini-1.5-flash-latest`.
- `GEMINI_RETRY_ATTEMPTS`, `GEMINI_RETRY_INITIAL_DELAY`, `GEMINI_RETRY_BACKOFF` – control retry/backoff strategy.
- `AI_SERVICE_DATABASE_URL` – Postgres connection string (defaults to `postgresql://postgres:postgres@postgres:5432/ai_skincare`).
- `AI_SERVICE_DB_POOL_MIN_SIZE` / `AI_SERVICE_DB_POOL_MAX_SIZE` – pool sizing.
- `AI_SERVICE_DB_STATEMENT_TIMEOUT_MS` – per-connection statement timeout in milliseconds.
- `AI_SERVICE_IMAGE_MAX_BYTES`, `AI_SERVICE_IMAGE_MAX_WIDTH`, `AI_SERVICE_IMAGE_MAX_HEIGHT` – hard caps for image payload size and dimensions.
- `AI_SERVICE_CACHE_TTL_SECONDS` – TTL for successful analysis cache entries.
- `AI_SERVICE_MAX_CONCURRENT` – number of analyses processed concurrently.
- `AI_SERVICE_SCAN_ENDPOINT`, `AI_SERVICE_SCAN_TIMEOUT_SECONDS` – optional malware scanning API endpoint (leave blank to disable).
- `AI_SERVICE_RATE_LIMIT_PER_USER`, `AI_SERVICE_RATE_LIMIT_PER_IP`, `AI_SERVICE_RATE_LIMIT_WINDOW_SECONDS` – rate limiting configuration.
- Tweak `GEMINI_TEMPERATURE`, `TOP_P`, `TOP_K`, and `MAX_OUTPUT_TOKENS` as needed.

**Endpoints**

- `GET /healthz` – service heartbeat.
- `POST /api/v1/analysis` – run a new analysis (`AnalysisRequest` payload) and returns `AnalysisResponse`.
- `GET /api/v1/analysis/{id}` – fetch stored analysis by ID.
- `GET /api/v1/analysis?user_id=` – list analyses for a user (supports filters: `severity`, `model_version`, `from_date`, `to_date`, `limit`, `offset`).
- `POST /api/v1/analysis/{id}/feedback` – record user feedback (currently logged only).

**Development**

```bash
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 3006
```

**Docker**

```bash
docker build -t healzone-ai-service .
docker run --rm -p 3006:3006 --env-file .env healzone-ai-service
```
