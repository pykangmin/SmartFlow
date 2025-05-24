from google.cloud import vision
from google.cloud import storage
import os
from ..core.config import settings

class OCRService:
    def __init__(self):
        self.vision_client = vision.ImageAnnotatorClient()
        self.storage_client = storage.Client()
        self.bucket = self.storage_client.bucket(settings.STORAGE_BUCKET_NAME)

    async def upload_image(self, image_data: bytes, filename: str) -> str:
        """이미지를 Google Cloud Storage에 업로드하고 URL을 반환합니다."""
        blob = self.bucket.blob(filename)
        blob.upload_from_string(image_data)
        return blob.public_url

    async def process_image(self, image_data: bytes) -> dict:
        """이미지를 OCR 처리하고 결과를 반환합니다."""
        image = vision.Image(content=image_data)
        response = self.vision_client.text_detection(image=image)
        texts = response.text_annotations

        if not texts:
            return {"error": "No text found in image"}

        # 전체 텍스트 추출
        full_text = texts[0].description

        # 여기에 영수증 데이터 파싱 로직 추가
        # 예: 날짜, 금액, 품목 등을 추출하는 로직

        return {
            "full_text": full_text,
            "parsed_data": {
                # 파싱된 데이터
            }
        } 