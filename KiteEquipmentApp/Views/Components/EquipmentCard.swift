//
//  EquipmentCard.swift
//  KiteEquipmentApp
//
//  Karta sprzętu
//

import SwiftUI

struct EquipmentCard: View {
    let equipment: Equipment
    let onUse: () -> Void
    
    @EnvironmentObject var equipmentViewModel: EquipmentViewModel
    @State private var showingEndConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(equipment.name)
                        .font(.headline)
                    
                    Text(equipment.type)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                StatusBadge(status: equipment.statusEnum)
            }
            
            // Identifier
            HStack {
                Image(systemName: "qrcode")
                    .foregroundColor(.secondary)
                Text(equipment.identifier)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            // Current use info (if in use)
            if equipment.isInUse, let instructor = equipment.currentInstructor {
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Instruktor:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(instructor)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Button {
                        showingEndConfirmation = true
                    } label: {
                        Text("Zakończ")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                }
            }
            
            // Use button (if available)
            if equipment.isAvailable {
                Button(action: onUse) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Użyj")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("Zakończ użycie", isPresented: $showingEndConfirmation) {
            Button("Anuluj", role: .cancel) { }
            Button("Zakończ", role: .destructive) {
                Task {
                    await equipmentViewModel.endUse(equipmentId: equipment.id)
                }
            }
        } message: {
            Text("Czy na pewno chcesz zakończyć użycie sprzętu \(equipment.name)?")
        }
    }
}

#Preview {
    VStack {
        EquipmentCard(equipment: .sample) {}
        EquipmentCard(equipment: .sampleInUse) {}
        EquipmentCard(equipment: .sampleService) {}
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .environmentObject(EquipmentViewModel())
}
