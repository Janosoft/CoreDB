$("#loginForm").submit(function (e) {
    e.preventDefault();
    const backend = e.originalEvent.submitter.value;
    let url = "";

    if (backend === "php") {
        url = "/CoreDB/backend/php/login.php";
    } else if (backend === "laravel") {
        url = "http://localhost:8000/api/login";
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