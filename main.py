from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    quantity: int = 1
    description: str | None = None


@app.post("/items")
async def create_item(item: Item) -> dict:
    return {
        "message": "Item created successfully",
        "item": item.model_dump(),
        "total": item.price * item.quantity,
    }


@app.get("/")
async def root():
    return {"message": "Welcome to the API"}
