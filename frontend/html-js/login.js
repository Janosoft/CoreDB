// ---------------------------------------------------
// Código del Botón Login
// ---------------------------------------------------

document.getElementById("loginForm").addEventListener("submit", async (e) => {
    e.preventDefault();

    // 1) Guardar el texto original y deshabilitar el botón
    const button = e.submitter;
    const originalText = button.textContent;
    button.disabled = true;
    button.textContent = "Espere...";

    // 2) Obtener datos del formulario
    let result;
    try {
        const email = document.getElementById("emailInput").value;
        const password = document.getElementById("passwordInput").value;
        const backend = e.submitter.value; // Define el backend a utilizar

        // 3) Llamada al backend correspondiente
        switch (backend) {
            case "php":
                result = await loginPHP(email, password);
                break;
            case "laravel":
                result = await loginLaravel(email, password);
                break;
            case "go":
                result = await loginGo(email, password);
                break;
            case "python":
                result = await loginPython(email, password);
                break;
            default:
                alert("Backend inválido");
                return;
        }
    } catch (error) {
        console.error(error);
        alert("Error inesperado");
    } finally {
        // 4) Restaurar el botón
        button.disabled = false;
        button.textContent = originalText;

        // 5) Mostrar el resultado
        if (result?.success) {
            alert("Login exitoso: " + result.data.email + " - " + result.data.codigo);
        } else if (result) {
            alert(result.error);
        } else {
            alert("Error inesperado");
        }
    }
});

// ---------------------------------------------------
// Login usando el backend PHP
// ---------------------------------------------------

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
        return { success: false, error: "Error de conexión" };
    }
}

// ---------------------------------------------------
// Login usando el backend Laravel
// ---------------------------------------------------

async function loginLaravel(email, password) {
    try {
        const response = await fetch("http://localhost:8000/api/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        return await response.json();

    } catch (error) {
        console.error("Error en loginLaravel:", error);
        return { success: false, error: "Error de conexión" };
    }
}

// ---------------------------------------------------
// Login usando el backend Go
// ---------------------------------------------------

async function loginGo(email, password) {
    try {
        const response = await fetch("http://localhost:8080/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        return await response.json();

    } catch (error) {
        console.error("Error en loginGo:", error);
        return { success: false, error: "Error de conexión" };
    }
}

// ---------------------------------------------------
// Login usando el backend Python
// ---------------------------------------------------

async function loginPython(email, password) {
    try {
        const response = await fetch("http://localhost:8000/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        return await response.json();

    } catch (error) {
        console.error("Error en loginPython:", error);
        return { success: false, error: "Error de conexión" };
    }
}