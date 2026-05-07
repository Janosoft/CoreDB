<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Usuario;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        if (!$request->filled(['email', 'password'])) {
            // No se recibieron los datos para el inicio de sesión
            return response()->json(['success' => false, 'error' => 'No se recibieron los datos necesarios.', 'data' => []], 400);
        }

        $email = $request->input('email');
        $password = $request->input('password');
        try {
            $user = Usuario::where('email', $email)->first();

            if (!$user) {
                // No se encontró el Usuario en la Base de Datos
                return response()->json(['success' => false, 'error' => 'Usuario no encontrado.', 'data' => []], 401);
            }

            if (!Hash::check($password, $user->password)) {
                // La contraseña no coincide con el hash
                return response()->json(['success' => false, 'error' => 'Contraseña incorrecta.', 'data' => []], 401);
            }

            // Inicio de sesión exitoso
            return response()->json(['success' => true, 'error' => "", 'data' => ['codigo' => $user->codigo, 'email' => $user->email]]);
        } catch (\Exception $e) {
            // Error interno del servidor
            return response()->json(['success' => false, 'error' => 'Error interno del servidor.', 'data' => []], 500);
        }
    }
}
