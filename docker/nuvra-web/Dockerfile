# Stage 1 — Builder
FROM python:3.11 AS builder
WORKDIR /app
COPY app.py .
RUN python -m py_compile app.py

# Stage 2 — Production (slim)
FROM python:3.11-slim AS production
WORKDIR /app
COPY --from=builder /app/app.py .
EXPOSE 8080
CMD ["python", "app.py"]
