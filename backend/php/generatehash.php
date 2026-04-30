<?php
// Genera un Hash para poder guardar una contraseña en la base de datos a mano, mientras se desarrolla el sistema.
// IMPORTANTE: Este archivo no se debe usar en producción.
$password = "CONTRASEÑA_SECRETA";
echo password_hash($password, PASSWORD_DEFAULT);
