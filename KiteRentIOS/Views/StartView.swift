import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.9), Color("GradientBottom")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "wind")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text("Kitesurfing School")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)

                Text("System Ewidencji Sprzętu")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 20)

                VStack(spacing: 4) {
                    Text("Zarządzaj sprzętem w czasie rzeczywistym")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text("Śledź dostępność • Skanuj QR • Historia użycia")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                VStack(spacing: 8) {
                    Text("Przesuń w górę, aby rozpocząć")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.9))

                    ArrowUpDownAnimation()
                }
                .padding(.bottom, 50)
            }
            .multilineTextAlignment(.center)
        }
    }
}

extension Color {
    static let gradientBottom = Color(red: 0.0, green: 0.4, blue: 1.0)
}

#Preview {
    StartView()
}
