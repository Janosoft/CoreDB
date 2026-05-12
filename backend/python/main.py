from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from db import get_connection
import bcrypt

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class LoginData(BaseModel):
    email: str
    password: str


def send_response(
    success: bool, error: str = "", data: dict = {}, status_code: int = 200
):
    return JSONResponse(
        status_code=status_code,
        content={"success": success, "error": error, "data": data},
    )


@app.post("/login")
def login(data: LoginData):

    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
            SELECT codigo, email, password
            FROM usuarios
            WHERE email = %s
        """

        cursor.execute(query, (data.email,))
        user = cursor.fetchone()

        if not user:
            return send_response(False, "Usuario no encontrado", {}, 401)

        if not bcrypt.checkpw(
            data.password.encode("utf-8"), user["password"].encode("utf-8")
        ):
            return send_response(False, "Contraseña incorrecta", {}, 401)

        return send_response(
            True, "", {"codigo": user["codigo"], "email": user["email"]}, 200
        )

    except Exception as e:

        with open("log.txt", "a") as file:
            file.write(str(e) + "\n")

        return send_response(False, "Error interno del servidor", {}, 500)

    finally:
        if "cursor" in locals():
            cursor.close()

        if "conn" in locals():
            conn.close()
