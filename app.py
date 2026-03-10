import msgspec
from litestar import Litestar, get, post
from litestar.status_codes import HTTP_201_CREATED


class Item(msgspec.Struct):
    name: str
    price: float
    quantity: int = 1
    description: str = "None"


@post("/litestar/items", status_code=HTTP_201_CREATED)
async def create_item(data: Item) -> dict:
    return {
        "message": "Item created successfully",
        "item": data,
        "total": data.price * data.quantity,
    }


@get("/litestar/")
async def root() -> dict:
    return {"message": "Welcome to the API"}


app = Litestar(route_handlers=[root, create_item])
