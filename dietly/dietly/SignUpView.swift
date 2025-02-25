import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSignedUp = false
    @State private var errorMessage: String = ""

    var body: some View {
        if isSignedUp {
            HomeView()
        } else {
            VStack(spacing: 20) {
                Text("Créer un compte")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)

                TextField("Pseudo", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                SecureField("Mot de passe", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                SecureField("Confirmer mot de passe", text: $confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                Button(action: {
                    signUp()
                }) {
                    Text("S'inscrire")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(passwordsMatch ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!passwordsMatch || username.isEmpty || email.isEmpty || password.isEmpty)
            }
            .padding()
            .navigationTitle("Créer un compte")
        }
    }

    var passwordsMatch: Bool {
        return password == confirmPassword && !password.isEmpty
    }

    // Fonction d'inscription a remplacer avec mon core data apres
    func signUp() {
        guard passwordsMatch else {
            errorMessage = "Les mots de passe ne correspondent pas."
            return
        }

        if username.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Veuillez remplir tous les champs."
            return
        }

        isSignedUp = true
    }
}
