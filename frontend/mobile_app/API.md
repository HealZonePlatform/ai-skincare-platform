# Mobile API Contract (frontend/mobile_app)

The Flutter app calls a small set of JSON endpoints exposed by the HealZone backend. All requests are JSON and should include the API version prefix `/api/v1` (see `ApiConstants` in code).

## Base URLs

| Environment | Base URL                       | Notes                              |
|-------------|--------------------------------|------------------------------------|
| Development | http://192.168.56.1:3001       | Local docker/compose gateway       |
| Staging     | https://staging-api.healzone.app | Production-like validation env     |
| Production  | https://api.healzone.app       | Customer-facing                    |

`APP_ENV` and optional `API_BASE_URL` overrides are provided via `--dart-define` at build time.

## Authentication

### POST /auth/login
Request:
```json
{ "email": "user@example.com", "password": "Secret123" }
```
Response:
```json
{ "data": { "accessToken": "<jwt>", "refreshToken": "<jwt>" } }
```

### POST /auth/register
Request includes the same fields as login plus profile attributes as needed.
Response shape matches `/auth/login`.

### POST /auth/refresh
Request:
```json
{ "refreshToken": "<jwt>" }
```
Response shape matches `/auth/login`.

## Dashboard

### GET /dashboard
Response (trimmed):
```json
{
  "greetingName": "Alex",
  "pulse": { "score": 82, "trend": [0.6,0.7,0.75], "delta": "+2", "mood": "Calm", "updated": "today" },
  "heroStats": [{ "label": "Hydration", "value": "60%", "icon": "water_drop", "detail": "+1", "color": 50335487 }],
  "pulseHighlights": [{ "label": "Barrier", "value": "Stable", "icon": "shield_moon", "color": 4293463287 }],
  "insights": [{ "title": "Balance actives", "caption": "Alternate nights", "icon": "science", "progress": 0.7, "iconColor": 4290950458 }],
  "routines": [{ "title": "AM reset", "focus": "Calming", "steps": ["Cleanse","Mist","SPF"], "minutes": 7, "bestMoment": "Morning", "icon": "timer", "accentColor": 4283653120 }],
  "articles": [{ "title": "Repair your barrier", "subtitle": "Less is more", "icon": "timeline", "readingTime": "4 min", "route": "/advice/barrier", "heroColor": 4288585374 }],
  "products": [{ "name": "Barrier Balm", "benefit": "Locks hydration", "rating": 4.7, "icon": "star", "route": "/products/barrier-balm", "badge": "Derm pick", "color": 4288585374, "imageUrl": "https://..." }]
}
```

## Profile

- `GET /users/profile` → `UserProfile`
- `PUT /users/profile` body example: `{ "fullName": "Alex Doe", "phoneNumber": "+84 912 345 678", "avatarUrl": "https://..." }`
- `POST /users/upload-avatar` body: multipart file upload, returns updated `UserProfile`
- `POST /users/change-password` body: `{ "currentPassword": "Old123", "newPassword": "New456" }`

## Skin Analysis

- `GET /analyses/history?page=1&pageSize=10` → array of `SkinAnalysisHistory` objects
- `GET /analyses/{id}` → detailed analysis (used by detail screen)
- `POST /analyses/upload` multipart file upload; response returns the created analysis ID and derived metrics. Current mobile flow stubs this call but keeps the contract for backend integration.

## Errors

Errors use a consistent envelope:
```json
{ "message": "Human readable summary", "code": "optional_code", "status": 401 }
```

- `401` → triggers token refresh and, on failure, forces logout.
- `4xx` → surfaced as validation/usage errors.
- `5xx` → shown as generic “Server error, try again later.”

All network errors are mapped to domain exceptions before reaching the UI (see `utils/error_handler.dart` and `HomeRemoteDataSource`).
