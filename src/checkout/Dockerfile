# ETAPA 1: BUILD
FROM node:22-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
RUN yarn build

# ETAPA 2: RUNTIME
FROM node:22-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./

RUN yarn install --frozen-lockfile --production \
    && yarn cache clean

USER nobody

EXPOSE 8080

CMD ["node", "dist/main.js"]
