//
//  KiteEquipmentApp.swift
//  KiteEquipmentApp
//
//  Natywna aplikacja iOS dla szkół kitesurfingu
//

import SwiftUI

@main
struct KiteEquipmentApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var equipmentViewModel = EquipmentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(equipmentViewModel)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                MainNavigationView()
            }
        }
        .onAppear {
            // Hide splash after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
            
            // Check for existing session
            authViewModel.checkSession()
        }
    }
}

struct MainNavigationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                AdminView()
            } else {
                GuestView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(EquipmentViewModel())
}
