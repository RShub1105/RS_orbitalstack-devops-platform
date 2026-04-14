from fastapi import FastAPI, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, generate_latest

app = FastAPI(title="ota-controller")
REQUEST_COUNTER = Counter(
    "ota_controller_http_requests_total",
    "Total HTTP requests for ota-controller",
    ["path"],
)
STATUS_GAUGE = Gauge(
    "ota_controller_service_up",
    "Service health indicator for ota-controller",
)


@app.middleware("http")
async def track_requests(request, call_next):
    REQUEST_COUNTER.labels(path=request.url.path).inc()
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
    STATUS_GAUGE.set(1)
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
