import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.9), Color("GradientBottom")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Image(systemName: "shield")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)

                    Text("DirectAdminLogin")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)

                    VStack(spacing: 12) {
                        TextField("email@domain.com", text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("••••••••", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)

                    HStack(spacing: 12) {
                        Button(action: {
                            dismiss() 
                        }) {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        Button(action: {
                        }) {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .padding(.vertical, 25)
                .frame(maxWidth: 320)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 10)

                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
