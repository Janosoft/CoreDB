async function loginPHP(email, password) {
    try {
        const response = await fetch("/CoreDB/backend/php/login.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        return await response.json();

    } catch (error) {
        console.error("Error en loginPHP:", error);
        return { success: false, message: "Error de conexión" };
    }
}