import SwiftUIstruct AdminDashboardView: View {
    var body: some View {
        ZStack {
            Color.mint.ignoresSafeArea()
            Text("Panel Administracyjny")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

struct DirectAdminLoginView: View {
    
    @StateObject private var viewModel = DirectAdminLoginViewModel()
    @Environment(\.dismiss) var dismiss 
    @State private var isAuthenticated = false
    
    var body: some View {
        
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.8),
                Color.blue.opacity(1.0)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack {
            VStack(spacing: 20) {
                
                Image(systemName: "lock.shield.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding(.top, 10)
                
                Text("DirectAdminLogin")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField("email@domain.com", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                SecureField("************", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .transition(.opacity)
                }
                
                HStack(spacing: 15) {
                    
                    Button("Cancel") {
                        dismiss() 
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button {
                        viewModel.login { success in
                            if success {
                                isAuthenticated = true
                            }
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 12)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(viewModel.isLoading)
                }
                .padding(.top, 10)
            }
            .padding(25)
            .background(.ultraThickMaterial)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
        }
        .fullScreenCover(isPresented: $isAuthenticated) {
            AdminDashboardView() 
        }
    }
}
