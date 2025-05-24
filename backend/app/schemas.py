from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

class ItemBase(BaseModel):
    name: str
    quantity: int
    unit_price: float
    total_price: float

class ItemCreate(ItemBase):
    pass

class Item(ItemBase):
    id: int
    receipt_id: int
    
    class Config:
        from_attributes = True

class ReceiptBase(BaseModel):
    total_amount: float
    receipt_date: datetime

class ReceiptCreate(ReceiptBase):
    pass

class Receipt(ReceiptBase):
    id: int
    user_id: int
    image_url: str
    ocr_data: Optional[dict] = None
    created_at: datetime
    items: List[Item] = []
    
    class Config:
        from_attributes = True

class UserBase(BaseModel):
    email: str
    business_name: Optional[str] = None

class UserCreate(UserBase):
    pass

class User(UserBase):
    id: int
    created_at: datetime
    receipts: List[Receipt] = []
    
    class Config:
        from_attributes = True 