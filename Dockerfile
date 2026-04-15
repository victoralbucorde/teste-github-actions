# ── build stage ───────────────────────────────────────────────────────────────
FROM python:3.12-slim AS builder

WORKDIR /build

COPY app/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ── runtime stage ─────────────────────────────────────────────────────────────
FROM python:3.12-slim

# OpenShift runs containers with arbitrary UIDs — non-root group 0 is the
# convention that keeps volume mounts working under SCC restricted.
RUN groupadd -g 1001 appgroup && \
    useradd -u 1001 -g appgroup -s /sbin/nologin -M appuser

WORKDIR /app

COPY --from=builder /install /usr/local
COPY app/ .

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

EXPOSE 8080

USER 1001

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]