from fastapi import FastAPI, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, generate_latest

app = FastAPI(title="telemetry-ingestor")
REQUEST_COUNTER = Counter(
    "telemetry_ingestor_http_requests_total",
    "Total HTTP requests for telemetry-ingestor",
    ["path"],
)
STATUS_GAUGE = Gauge(
    "telemetry_ingestor_service_up",
    "Service health indicator for telemetry-ingestor",
)


@app.middleware("http")
async def track_requests(request, call_next):
    REQUEST_COUNTER.labels(path=request.url.path).inc()
    return await call_next(request)


@app.get("/ready")
def ready():
    return {"status": "ready", "service": "telemetry-ingestor"}


@app.get("/health")
def health():
    return {"status": "ok", "service": "telemetry-ingestor"}


@app.get("/metrics")
def metrics():
    STATUS_GAUGE.set(1)
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
