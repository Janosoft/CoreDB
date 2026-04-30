<?php
require_once 'db.php';
header('Content-Type: application/json');

function sendResponse(bool $success, string $error = "", array $data = [])
{
    echo json_encode(["success" => $success, "error" => $error, "data" => $data]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);
if (!$data || !isset($data['email'], $data['password'])) {
    // No se recibieron los datos para el inicio de sesión
    http_response_code(400);
    sendResponse(false, "No se recibieron los datos necesarios.");
}

try {
    $pdo = getConnection();
    $stmt = $pdo->prepare("SELECT codigo, email, password FROM usuarios WHERE email = :email");
    $stmt->execute(['email' => $data['email']]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        // No se encontró el Usuario en la Base de Datos
        http_response_code(401);
        sendResponse(false, "Usuario no encontrado.");
    }

    if (!password_verify($data['password'], $user['password'])) {
        // La contraseña no coincide con el hash
        http_response_code(401);
        sendResponse(false, "Contraseña incorrecta.");
    }

    // Inicio de sesión exitoso
    http_response_code(200);
    sendResponse(true, "", ["codigo" => $user['codigo'], "email" => $user['email']]);
} catch (Throwable $e) {
    http_response_code(500);
    file_put_contents(__DIR__ . "/log.txt", "[" . date("Y-m-d H:i:s") . "] " . $e->getMessage() . PHP_EOL, FILE_APPEND);
    sendResponse(false, "Error interno del servidor");
}
