# HealZone Web Dashboard

Front-office dashboard for HealZone partners, experts, and platform administrators. The current
implementation ships a fully client-side Next.js 14 App Router setup with mocked data and role
specific workspaces so the product team can iterate quickly on UX before APIs are ready.

## Tech Stack
- Next.js 14 (App Router) + TypeScript
- Tailwind CSS with custom brand palette
- React Query for data access layer scaffolding
- Jest + Testing Library (ready for future tests)

## Getting Started
```bash
npm install         # install dependencies
npm run dev         # start local dev server on http://localhost:3000
npm run lint        # run eslint (Next.js rules + prettier)
npm run typecheck   # ensure TypeScript project compiles
npm run test        # execute Jest suite (empty for now)
```

## Project Structure
```
frontend/web-dashboard
├── IMPLEMENTATION_PLAN.md          # Detailed backlog for future work
├── src/
│   ├── app/                         # App Router routes grouped by role
│   ├── components/                  # Shared UI and dashboard widgets
│   ├── data/mockData.ts             # Centralised mock datasets
│   ├── hooks/                       # React Query + state helpers
│   ├── providers/                   # Global providers (role, react-query)
│   └── types/                       # Domain specific TypeScript types
└── config files (tailwind, eslint, jest, etc.)
```

Key routes live under `src/app/(dashboard)`:
- `/partner/*` – product catalogue, insights, scheduling
- `/expert/*` – review queue, detail workflow, resources
- `/admin/*` – system overview, user management, approvals, reports

The navigation map is defined in `src/config/navigation.tsx` so new sections stay in sync with the
sidebar and role switcher.

## Mock Data & State
Temporary data lives in `src/data/mockData.ts` and is consumed through lightweight hooks
(`useProducts`, `useReviews`, `useUsers`, `usePartnerInsights`). Replace these with real API calls by
swapping the hook internals once backend endpoints are ready.

Global context:
- `RoleProvider` stores the active dashboard role for the current session.
- `AppProviders` sets up React Query and the role context for the entire app.

## Next Steps
See `IMPLEMENTATION_PLAN.md` for the full backlog. Immediate priorities once APIs arrive:
1. Replace mock hooks with typed API clients (Axios + React Query mutations).
2. Implement authentication guard + refresh token flow via Auth Service.
3. Wire upload widgets (images, documents) to storage/backoffice endpoints.
4. Add Jest/Playwright coverage for critical dashboards before release.
