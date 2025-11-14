//
//  GuestView.swift
//  KiteEquipmentApp
//
//  Widok dla instruktorów (goście)
//

import SwiftUI

struct GuestView: View {
    @EnvironmentObject var equipmentViewModel: EquipmentViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLoginSheet = false
    @State private var showQRScanner = false
    @State private var selectedEquipment: Equipment?
    @State private var showUseModal = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                VStack(spacing: 0) {
                    // Search and filter bar
                    SearchFilterBar()
                    
                    // Equipment list
                    if equipmentViewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if equipmentViewModel.filteredEquipment.isEmpty {
                        EmptyStateView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(equipmentViewModel.filteredEquipment) { equipment in
                                    EquipmentCard(equipment: equipment) {
                                        selectedEquipment = equipment
                                        showUseModal = true
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                // QR Scanner button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showQRScanner = true
                        } label: {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Sprzęt")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showLoginSheet = true
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.system(size: 24))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await equipmentViewModel.loadEquipment()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginView()
            }
            .sheet(isPresented: $showQRScanner) {
                QRScannerView { code in
                    // Find equipment by code
                    if let equipment = equipmentViewModel.equipment.first(where: { $0.identifier == code }) {
                        selectedEquipment = equipment
                        showUseModal = true
                    }
                    showQRScanner = false
                }
            }
            .sheet(item: $selectedEquipment) { equipment in
                UseEquipmentSheet(equipment: equipment, isPresented: $showUseModal)
            }
        }
        .task {
            await equipmentViewModel.loadEquipment()
        }
    }
}

// MARK: - Search and Filter Bar
struct SearchFilterBar: View {
    @EnvironmentObject var equipmentViewModel: EquipmentViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Szukaj sprzętu...", text: $equipmentViewModel.searchText)
                    .textFieldStyle(.plain)
                
                if !equipmentViewModel.searchText.isEmpty {
                    Button {
                        equipmentViewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "Wszystkie",
                        isSelected: equipmentViewModel.selectedType == nil
                    ) {
                        equipmentViewModel.selectedType = nil
                    }
                    
                    ForEach(Constants.equipmentTypes, id: \.self) { type in
                        FilterChip(
                            title: type,
                            isSelected: equipmentViewModel.selectedType == type
                        ) {
                            equipmentViewModel.selectedType = type
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color(.systemBackground))
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .cornerRadius(20)
        }
    }
}

// MARK: - Empty State
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Brak sprzętu")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Nie znaleziono żadnego sprzętu")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GuestView()
        .environmentObject(EquipmentViewModel())
        .environmentObject(AuthViewModel())
}
