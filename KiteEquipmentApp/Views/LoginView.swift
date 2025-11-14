//
//  LoginView.swift
//  KiteEquipmentApp
//
//  Ekran logowania administratora
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Hasło", text: $password)
                        .textContentType(.password)
                } header: {
                    Text("Dane logowania")
                }
                
                if let error = authViewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Section {
                    Button {
                        login()
                    } label: {
                        HStack {
                            Spacer()
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else {
                                Text("Zaloguj się")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pierwsze uruchomienie?")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        Text("Otwórz setup-sample-data.html w przeglądarce, aby utworzyć konto administratora.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Domyślne dane logowania:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text("Email: admin@kiteschool.com")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .foregroundColor(.secondary)
                        
                        Text("Hasło: Admin123!")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Logowanie Administratora")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
            }
            .onChange(of: authViewModel.isAuthenticated) { _, isAuthenticated in
                if isAuthenticated {
                    dismiss()
                }
            }
        }
    }
    
    private func login() {
        Task {
            await authViewModel.login(email: email, password: password)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
