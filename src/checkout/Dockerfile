# ETAPA 1: BUILD
FROM node:22-alpine AS builder

WORKDIR /app

RUN corepack enable

ENV YARN_ENABLE_SCRIPTS=false

COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn/releases/ ./.yarn/releases/

RUN yarn install --immutable

COPY . .
RUN yarn build

# ETAPA 2: RUNTIME
FROM node:22-alpine

WORKDIR /app

RUN corepack enable

ENV YARN_ENABLE_SCRIPTS=false

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./
COPY --from=builder /app/.yarnrc.yml ./
COPY --from=builder /app/.yarn/releases/ ./.yarn/releases/

RUN yarn workspaces focus --production

USER nobody

EXPOSE 8080

CMD ["node", "dist/main.js"]