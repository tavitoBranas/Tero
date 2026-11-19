# ETAPA 1: BUILD
FROM python:3.12-alpine AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ETAPA 2: RUNTIME
FROM python:3.12-alpine

WORKDIR /app

COPY --from=builder /install /usr/local

COPY . .

ENV CART_PERSISTENCE_PROVIDER=in-memory
ENV PORT=8080

USER nobody

EXPOSE 8080

CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port $PORT"]
