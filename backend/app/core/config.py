from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://user:password@localhost:5432/smartflow"
    GOOGLE_CLOUD_PROJECT: str = "smartflow-460806"
    GOOGLE_APPLICATION_CREDENTIALS: str = "credentials.json"
    SECRET_KEY: str = "smartflow-secret-key-2024"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    STORAGE_BUCKET_NAME: str = "smartflow-receipts"

    class Config:
        env_file = ".env"

settings = Settings() 