//
//  UseEquipmentSheet.swift
//  KiteEquipmentApp
//
//  Modal do rozpoczęcia użycia sprzętu
//

import SwiftUI

struct UseEquipmentSheet: View {
    let equipment: Equipment
    @Binding var isPresented: Bool
    
    @EnvironmentObject var equipmentViewModel: EquipmentViewModel
    @State private var instructorName = ""
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Nazwa:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(equipment.name)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Typ:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(equipment.type)
                    }
                    
                    HStack {
                        Text("Identyfikator:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(equipment.identifier)
                            .font(.system(.body, design: .monospaced))
                    }
                } header: {
                    Text("Sprzęt")
                }
                
                Section {
                    TextField("Wprowadź swoje imię i nazwisko", text: $instructorName)
                        .textContentType(.name)
                        .autocapitalization(.words)
                } header: {
                    Text("Instruktor")
                } footer: {
                    Text("Podaj swoje imię i nazwisko aby rozpocząć użycie sprzętu")
                }
                
                Section {
                    Button {
                        startUse()
                    } label: {
                        HStack {
                            Spacer()
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else {
                                Text("Rozpocznij użycie")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(instructorName.isEmpty || isSubmitting)
                }
            }
            .navigationTitle("Użyj sprzęt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func startUse() {
        guard !instructorName.isEmpty else { return }
        
        isSubmitting = true
        
        Task {
            let success = await equipmentViewModel.startUse(
                equipmentId: equipment.id,
                instructor: instructorName
            )
            
            isSubmitting = false
            
            if success {
                isPresented = false
            }
        }
    }
}

#Preview {
    UseEquipmentSheet(
        equipment: .sample,
        isPresented: .constant(true)
    )
    .environmentObject(EquipmentViewModel())
}
