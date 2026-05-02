$("#loginForm").submit(function (e) {
    e.preventDefault();

    $.ajax({
        url: "/CoreDB/backend/php/login.php",
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