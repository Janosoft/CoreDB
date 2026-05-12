$("#loginForm").submit(function (e) {
    e.preventDefault();
    const backend = e.originalEvent.submitter.value;
    let url = "";

    switch (backend) {
        case "php":
            url = "/CoreDB/backend/php/login.php";
            break;
        case "laravel":
            url = "http://localhost:8000/api/login";
            break;
        case "go":
            url = "http://localhost:8080/login";
            break;
        case "python":
            url = "http://localhost:8000/login";
            break;
        default:
            alert("Backend inválido");
            return;
    }

    $.ajax({
        url: url,
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({
            email: $("#emailInput").val(),
            password: $("#passwordInput").val()
        }),
        success: function (res) {
            if (res.success) alert("Login exitoso: " + res.data.email + " - " + res.data.codigo);
            else alert("Error: " + res.error);
        }
    });
});