from fastapi import FastAPI, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, generate_latest

app = FastAPI(title="ota-controller")
REQUEST_COUNTER = Counter("http_requests_total", "Total HTTP requests", ["service", "path"])
STATUS_GAUGE = Gauge("service_up", "Service health indicator", ["service"])


@app.middleware("http")
async def track_requests(request, call_next):
    REQUEST_COUNTER.labels(service="ota-controller", path=request.url.path).inc()
    return await call_next(request)


@app.get("/ready")
def ready():
    return {"status": "ready", "service": "ota-controller"}


@app.get("/health")
def health():
    return {"status": "ok", "service": "ota-controller"}


@app.post("/drain")
def drain():
    return {"status": "draining"}


@app.get("/metrics")
def metrics():
    STATUS_GAUGE.labels(service="ota-controller").set(1)
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
