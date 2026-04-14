from fastapi.testclient import TestClient
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

spec = spec_from_file_location("device_api_main", Path(__file__).with_name("main.py"))
module = module_from_spec(spec)
spec.loader.exec_module(module)
app = module.app

client = TestClient(app)


def test_live():
    response = client.get("/health/live")
    assert response.status_code == 200
