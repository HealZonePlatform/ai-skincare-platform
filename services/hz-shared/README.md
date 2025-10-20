# hz-shared

Shared utility library for HealZone microservices. Provides helpers for JWT verification, HTTP errors, request validation, and PostgreSQL pooling.

## Usage

Add a local dependency in a service `package.json`:

```json
"dependencies": {
  "hz-shared": "file:../hz-shared"
}
```

Then install and import:

```bash
npm install
```

```ts
import { jwtUtil, errors, validate, db } from 'hz-shared';
```
