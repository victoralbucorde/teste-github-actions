import os
from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI(title="Hello World Backend", version="1.0.0")

APP_VERSION = os.getenv("APP_VERSION", "dev")
ENVIRONMENT = os.getenv("ENVIRONMENT", "local")


@app.get("/")
def hello_world():
    return JSONResponse({
        "message": "Hello, World!",
        "version": APP_VERSION,
        "environment": ENVIRONMENT,
    })


@app.get("/health")
def health():
    return JSONResponse({"status": "ok"})