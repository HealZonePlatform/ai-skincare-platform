# HealZone Web Dashboard – Implementation Plan

## 0. Foundation
- [ ] Scaffold Next.js 14 (App Router) + TypeScript + Tailwind + shadcn/ui baseline
- [ ] Configure project metadata (`package.json`, `tsconfig.json`, `next.config.js`, `tailwind.config.ts`)
- [ ] Set up linting & formatting (`eslint`, `prettier`)
- [ ] Establish absolute import aliases and shared type directory

## 1. Core Layout & Navigation
- [ ] `app/layout.tsx` with global providers (theme, auth stub)
- [ ] Shell layout: sidebar navigation, top bar, responsive breakpoints
- [ ] Route grouping per role (`(partner)`, `(expert)`, `(admin)`)
- [ ] Shared UI primitives (`DataTable`, `StatCard`, `Badge`, `StatusPill`)

## 2. Authentication & Access Control (stubbed)
- [ ] Token-aware API client scaffold (`lib/api/client.ts`)
- [ ] Auth context + hook (`providers/AuthProvider`, `hooks/useAuth.ts`)
- [ ] Route guards for protected pages (`components/auth/ProtectedRoute.tsx`)
- [ ] Mock sign-in flow for local development

## 3. Partner Module
- [ ] Overview dashboard (`app/(partner)/dashboard/page.tsx`)
- [ ] Product catalogue table with filters/sorts
- [ ] Product creation wizard (multi-step form, validation)
- [ ] Partner analytics widgets (traffic, conversion, rating)

## 4. Expert Module
- [ ] Review queue page with prioritised list
- [ ] Product review detail view
- [ ] Review submission form + comment threads
- [ ] History tab with filters and status pills

## 5. Admin Module
- [ ] System overview dashboard (metrics & alerts)
- [ ] User management table with CRUD stubs
- [ ] Approval queue with expert recommendations
- [ ] Platform settings page (feature flags, thresholds)

## 6. Shared Utilities
- [ ] Query hooks scaffold (`hooks/useProducts`, etc.) using React Query
- [ ] Validation utilities (Zod schemas)
- [ ] Formatting helpers (dates, status labels)

## 7. Testing & QA
- [ ] Configure Jest + Testing Library
- [ ] Snapshot tests for layout and critical components
- [ ] Unit tests for utilities and hooks
- [ ] Manual test checklist documenting primary flows

## 8. Documentation & DX
- [ ] Update `README.md` with setup instructions & module overview
- [ ] Add architecture overview in `docs/05_WEB_DASHBOARD_PLAN.md` appendix
- [ ] Document API contract expectations (stubs) for backend team
- [ ] Create contributor checklist (lint, test, typecheck)

