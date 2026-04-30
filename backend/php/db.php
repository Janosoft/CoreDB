<?php

function getConnection(string $env = 'development'): PDO
{
    $config = json_decode(file_get_contents(__DIR__ . '/../../db/mysql/config.json'), true);
    $dbConfig = $config['db'][$env];
    if (!$config || !isset($config['db'][$env])) throw new Exception("CoreDB Error: No se encontró configuración para el entorno '{$env}'");

    try {
        $pdo = new PDO("mysql:host={$dbConfig['host']};dbname={$dbConfig['database']};charset=utf8mb4", $dbConfig['user'], $dbConfig['password']);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    } catch (PDOException $e) {
        throw new Exception("CoreDB Error: " . $e->getMessage(), (int)$e->getCode());
    }
}
