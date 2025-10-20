FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json tsconfig.json ./
COPY ../hz-shared /usr/src/hz-shared

RUN npm install --prefix /usr/src/hz-shared && \
    npm run build --prefix /usr/src/hz-shared

RUN npm install

COPY src ./src
COPY sql ./sql
COPY scripts ./scripts

RUN npm run build
RUN npm prune --omit=dev

FROM node:20-alpine AS runner

WORKDIR /usr/src/app
ENV NODE_ENV=production

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/package.json ./package.json
COPY --from=builder /usr/src/app/package-lock.json ./package-lock.json
COPY sql ./sql
COPY scripts ./scripts

EXPOSE 3004

CMD ["node", "dist/server.js"]
