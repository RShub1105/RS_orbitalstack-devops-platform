from fastapi import FastAPI, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, generate_latest

app = FastAPI(title="device-api")
REQUEST_COUNTER = Counter(
    "device_api_http_requests_total",
    "Total HTTP requests for device-api",
    ["path"],
)
STATUS_GAUGE = Gauge(
    "device_api_service_up",
    "Service health indicator for device-api",
)


@app.middleware("http")
async def track_requests(request, call_next):
    REQUEST_COUNTER.labels(path=request.url.path).inc()
    return await call_next(request)


@app.get("/health/ready")
def ready():
    return {"status": "ready", "service": "device-api"}


@app.get("/health/live")
def live():
    return {"status": "ok", "service": "device-api"}


@app.get("/metrics")
def metrics():
    STATUS_GAUGE.set(1)
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
