from fastapi import FastAPI, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, generate_latest
import os


SERVICE_NAME = os.getenv("SERVICE_NAME", "service")

app = FastAPI(title=SERVICE_NAME)

REQUEST_COUNTER = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["service", "path"],
)
STATUS_GAUGE = Gauge(
    "service_up",
    "Service health indicator",
    ["service"],
)


@app.middleware("http")
async def track_requests(request, call_next):
    REQUEST_COUNTER.labels(service=SERVICE_NAME, path=request.url.path).inc()
    return await call_next(request)


@app.get("/metrics")
def metrics():
    STATUS_GAUGE.labels(service=SERVICE_NAME).set(1)
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

