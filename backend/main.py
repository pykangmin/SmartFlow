from fastapi import FastAPI, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from app import models, schemas
from app.database import engine, get_db
from app.services.ocr_service import OCRService
import os
from datetime import datetime

# models.Base.metadata.create_all(bind=engine)  # 임시로 주석 처리

app = FastAPI(title="Smart Flow API")
# ocr_service = OCRService()  # 임시로 주석 처리 (Google Cloud 설정 필요)

@app.post("/upload-receipt/")
async def upload_receipt(
    file: UploadFile = File(...),
    # db: Session = Depends(get_db)  # 임시로 주석 처리
):
    """영수증 이미지를 업로드하고 OCR 처리합니다."""
    try:
        # 이미지 데이터 읽기
        image_data = await file.read()
        
        # TODO: 이미지 업로드
        # filename = f"receipts/{datetime.now().strftime('%Y%m%d_%H%M%S')}_{file.filename}"
        # image_url = await ocr_service.upload_image(image_data, filename)
        
        # TODO: OCR 처리
        # ocr_result = await ocr_service.process_image(image_data)
        
        # TODO: OCR 결과를 데이터베이스에 저장
        
        return {
            "message": "Receipt processed successfully (demo mode)",
            "filename": file.filename,
            "file_size": len(image_data)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
async def root():
    return {"message": "Welcome to Smart Flow API"} 