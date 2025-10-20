# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Build/Lint/Test Commands

- Main application: `npm run build`, `npm run dev`, `npm run lint`, `npm run export`
- Auth service: `npm run build`, `npm run dev`, `npm run test`, `npm run lint`
- Static export for GitHub Pages: `npm run build && npm run export`

## Code Style Rules

- TypeScript: Use camelCase for variables/functions, PascalCase for classes/interfaces
- Dart (Flutter): Use camelCase for variables/functions, PascalCase for classes/enums, snake_case for files
- SQL: Use UPPER CASE for keywords, lower case for table/column names
- Avoid using `any` type in TypeScript except when absolutely necessary
- Use type definitions for all variables and functions

## Custom Utilities & Design Patterns

- Next.js 14 App Router with static export configuration for GitHub Pages deployment
- Provider pattern for state management in Flutter mobile app
- Custom Tailwind CSS theme with brand-specific color palette
- Google Analytics integration with gtag
- Lazy loading for images using react-lazy-load-image-component
- JWT-based authentication with refresh token mechanism

## Gotchas

- Next.js configured with `output: 'export'` for static deployment - no server-side rendering
- Mobile app uses Flutter with specific dependencies managed via pubspec.yaml
- Docker compose uses specific service names for inter-service communication (postgres, redis)
- CORS configured for specific origins in auth service
- Custom error handling and logging implemented across services