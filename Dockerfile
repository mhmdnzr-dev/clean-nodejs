# Dockerfile
FROM node:20-alpine AS base
WORKDIR /app

# ---- Build -------------------------------------------------
FROM base AS builder
COPY package.json ./
RUN npm i --force               # installs typescript (devDep)
COPY tsconfig.json ./
COPY src ./src
COPY apps ./apps
RUN npx tsc                     # uses the copied tsconfig.json

# ---- Runtime (tiny) ---------------------------------------
FROM alpine:3.20
RUN apk add --no-cache nodejs
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

EXPOSE 3000
CMD ["node", "dist/apps/api/main.js"]