# HealZone Web Dashboard – Implementation Plan

## 0. Foundation
- [x] Scaffold Next.js 14 (App Router) + TypeScript + Tailwind baseline
- [x] Configure project metadata (`package.json`, `tsconfig.json`, `next.config.js`, `tailwind.config.ts`)
- [x] Set up linting & formatting (`eslint`, `prettier`)
- [x] Establish absolute import aliases and shared type directory

## 1. Core Layout & Navigation
- [x] `app/layout.tsx` with global providers (React Query + role context)
- [x] Dashboard shell: sidebar navigation, top bar, responsive breakpoints
- [x] Route grouping per role (`(partner)`, `(expert)`, `(admin)`)
- [x] Shared UI primitives (`DataTable`, `StatCard`, `Badge`, `StatusPill`, buttons, inputs)

## 2. Authentication & Access Control (stubbed)
- [ ] Token-aware API client scaffold (`lib/api/client.ts`)
- [ ] Auth context + hook (`providers/AuthProvider`, `hooks/useAuth.ts`)
- [ ] Route guards for protected pages (`components/auth/ProtectedRoute.tsx`)
- [ ] Mock sign-in flow for local development

## 3. Partner Module
- [x] Overview dashboard (`/partner/overview`)
- [x] Product catalogue table with filters/sorts
- [ ] Product creation wizard (multi-step form, validation)
- [x] Partner insights & analytics widgets

## 4. Expert Module
- [x] Review queue page with prioritised list
- [x] Product review detail view
- [ ] Review submission form + comment threads
- [x] History tab with filters and status pills

## 5. Admin Module
- [x] System overview dashboard (metrics & alerts)
- [x] User management table with filters
- [x] Approval queue with expert recommendations
- [x] Platform settings page (feature flags, thresholds)
- [x] Reports page for recurring exports

## 6. Shared Utilities
- [x] Query hooks scaffold (`useProducts`, `useReviews`, `useUsers`, `usePartnerInsights`)
- [ ] Validation utilities (Zod schemas)
- [ ] Formatting & number/date helpers beyond basics

## 7. Testing & QA
- [x] Configure Jest + Testing Library
- [ ] Snapshot tests for layout and critical components
- [ ] Unit tests for utilities and hooks
- [ ] Manual test checklist documenting primary flows

## 8. Documentation & DX
- [x] Update `README.md` with setup instructions & module overview
- [ ] Add architecture appendix in `docs/05_WEB_DASHBOARD_PLAN.md`
- [ ] Document API contract expectations (stubs) for backend team
- [ ] Create contributor checklist (lint, test, typecheck)
