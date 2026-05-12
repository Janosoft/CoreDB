import SwiftUI

// Estructura para decodificar la respuesta del servidor
struct LoginResponse: Codable {
    let success: Bool
    let error: String?
    let data: LoginData?

    enum CodingKeys: String, CodingKey {
        case success, error, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        error = try container.decodeIfPresent(String.self, forKey: .error)
        data = try? container.decodeIfPresent(LoginData.self, forKey: .data)
    }
}

struct LoginData: Codable {
    let email: String?
    let codigo: String?

    enum CodingKeys: String, CodingKey {
        case email, codigo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        
        if let stringValue = try? container.decodeIfPresent(String.self, forKey: .codigo) {
            codigo = stringValue
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .codigo) {
            codigo = String(intValue)
        } else {
            codigo = nil
        }
    }
}

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isLoading = false
    @State private var messageColor: Color = .gray

    var body: some View {
        VStack(spacing: 20) {
            
            // Campos de entrada
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                
                SecureField("Contraseña", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            
            // Botones de Backend
            VStack(spacing: 10) {
                Button(action: { login(backend: "php") }) {
                    labelForButton("PHP backend")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)

                Button(action: { login(backend: "laravel") }) {
                    labelForButton("Laravel backend")
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .disabled(isLoading)

                Button(action: { login(backend: "go") }) {
                    labelForButton("Go backend")
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .disabled(isLoading)
                
                Button(action: { login(backend: "python") }) {
                    labelForButton("Python backend")
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .disabled(isLoading)
            }

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(messageColor)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(messageColor.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(30)
        .frame(width: 400)
    }

    // Helper para mostrar texto o spinner en botones
    @ViewBuilder
    func labelForButton(_ text: String) -> some View {
        HStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(.trailing, 5)
            }
            Text(isLoading ? "Espere..." : "Iniciar Sesión (\(text))")
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 35)
    }

    func login(backend: String) {
        let urlString: String
        switch backend {
        case "php":
            urlString = "http://127.0.0.1/CoreDB/backend/php/login.php"
        case "laravel":
            urlString = "http://localhost:8000/api/login"
        case "go":
            urlString = "http://localhost:8080/login"
        case "python":
            urlString = "http://localhost:8000/login"
        default:
            return
        }

        guard let url = URL(string: urlString) else {
            showError("URL inválida")
            return
        }

        isLoading = true
        message = ""

        let body: [String: String] = [
            "email": email,
            "password": password
        ]

        guard let jsonData = try? JSONEncoder().encode(body) else {
            showError("Error al preparar datos")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.showError("Error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    self.showError("Sin respuesta del servidor")
                    return
                }

                // Intentar decodificar la respuesta JSON
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(LoginResponse.self, from: data)
                    
                    if result.success {
                        let userEmail = result.data?.email ?? "?"
                        let userCodigo = result.data?.codigo ?? "?"
                        self.showSuccess("Login exitoso: \(userEmail) - \(userCodigo)")
                    } else {
                        self.showError(result.error ?? "Error desconocido")
                    }
                } catch {
                    // Si falla el decoder, mostrar el texto crudo para debug
                    let rawResponse = String(data: data, encoding: .utf8) ?? "Ininteligible"
                    print("Error decodificando: \(error)")
                    self.showError("Error en formato de respuesta: \(rawResponse)")
                }
            }
        }.resume()
    }

    func showError(_ msg: String) {
        message = msg
        messageColor = .red
    }

    func showSuccess(_ msg: String) {
        message = msg
        messageColor = .green
    }
}

#Preview {
    ContentView()
}
