# ETAPA 1: BUILD
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ETAPA 2: RUNTIME
FROM node:22-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

RUN npm ci --omit=dev && npm cache clean --force

ENV PORT=8080

USER nobody

EXPOSE 8080

CMD ["node", "dist/app.js"]
