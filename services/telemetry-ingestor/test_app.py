from fastapi.testclient import TestClient
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

spec = spec_from_file_location("telemetry_ingestor_main", Path(__file__).with_name("main.py"))
module = module_from_spec(spec)
spec.loader.exec_module(module)
app = module.app

client = TestClient(app)


def test_ready():
    response = client.get("/ready")
    assert response.status_code == 200
