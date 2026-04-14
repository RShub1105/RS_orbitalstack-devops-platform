from fastapi import FastAPI, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, generate_latest

app = FastAPI(title="device-api")
REQUEST_COUNTER = Counter("http_requests_total", "Total HTTP requests", ["service", "path"])
STATUS_GAUGE = Gauge("service_up", "Service health indicator", ["service"])


@app.middleware("http")
async def track_requests(request, call_next):
    REQUEST_COUNTER.labels(service="device-api", path=request.url.path).inc()
    return await call_next(request)


@app.get("/health/ready")
def ready():
    return {"status": "ready", "service": "device-api"}


@app.get("/health/live")
def live():
    return {"status": "ok", "service": "device-api"}


@app.get("/metrics")
def metrics():
    STATUS_GAUGE.labels(service="device-api").set(1)
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
