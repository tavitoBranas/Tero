# ETAPA 1: BUILD
FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o orders .

# ETAPA 2: RUNTIME
FROM alpine:3.22

WORKDIR /app

COPY --from=builder /app/orders .

USER nobody

EXPOSE 8080

CMD ["./orders"]
