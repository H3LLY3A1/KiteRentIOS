//
//  AdminView.swift
//  KiteEquipmentApp
//
//  Panel administratora
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var equipmentViewModel: EquipmentViewModel
    
    @State private var selectedTab = 0
    @State private var showingAddEquipment = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Equipment Management
            EquipmentManagementView()
                .tabItem {
                    Label("Sprzęt", systemImage: "list.bullet")
                }
                .tag(0)
            
            // History
            HistoryView()
                .tabItem {
                    Label("Historia", systemImage: "clock")
                }
                .tag(1)
            
            // Settings
            SettingsView()
                .tabItem {
                    Label("Ustawienia", systemImage: "gearshape")
                }
                .tag(2)
        }
    }
}

// MARK: - Equipment Management View
struct EquipmentManagementView: View {
    @EnvironmentObject var equipmentViewModel: EquipmentViewModel
    @State private var showingAddSheet = false
    @State private var editingEquipment: Equipment?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(equipmentViewModel.filteredEquipment) { equipment in
                    EquipmentRow(equipment: equipment)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editingEquipment = equipment
                        }
                }
                .onDelete(perform: deleteEquipment)
            }
            .navigationTitle("Zarządzanie Sprzętem")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
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
            .sheet(isPresented: $showingAddSheet) {
                AddEquipmentSheet()
            }
            .sheet(item: $editingEquipment) { equipment in
                EditEquipmentSheet(equipment: equipment)
            }
            .task {
                await equipmentViewModel.loadEquipment()
            }
        }
    }
    
    private func deleteEquipment(at offsets: IndexSet) {
        for index in offsets {
            let equipment = equipmentViewModel.filteredEquipment[index]
            Task {
                await equipmentViewModel.deleteEquipment(id: equipment.id)
            }
        }
    }
}

// MARK: - Equipment Row
struct EquipmentRow: View {
    let equipment: Equipment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(equipment.name)
                    .font(.headline)
                
                Spacer()
                
                StatusBadge(status: equipment.statusEnum)
            }
            
            HStack {
                Text(equipment.type)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(equipment.identifier)
                    .font(.caption)
                    .fontDesign(.monospaced)
                    .foregroundColor(.secondary)
            }
            
            if equipment.isInUse, let instructor = equipment.currentInstructor {
                HStack {
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text(instructor)
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Equipment Sheet
struct AddEquipmentSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var equipmentViewModel: EquipmentViewModel
    
    @State private var name = ""
    @State private var type = "Latawiec"
    @State private var identifier = ""
    @State private var status = Constants.EquipmentStatus.available.rawValue
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Dane sprzętu") {
                    TextField("Nazwa", text: $name)
                    
                    Picker("Typ", selection: $type) {
                        ForEach(Constants.equipmentTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    TextField("Identyfikator (np. KITE-001)", text: $identifier)
                        .textInputAutocapitalization(.characters)
                    
                    Picker("Status", selection: $status) {
                        ForEach(Constants.EquipmentStatus.allCases, id: \.self) { status in
                            Text(status.displayName).tag(status.rawValue)
                        }
                    }
                }
                
                Section {
                    Button {
                        addEquipment()
                    } label: {
                        HStack {
                            Spacer()
                            if isSubmitting {
                                ProgressView()
                            } else {
                                Text("Dodaj sprzęt")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(name.isEmpty || identifier.isEmpty || isSubmitting)
                }
            }
            .navigationTitle("Nowy sprzęt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addEquipment() {
        isSubmitting = true
        
        Task {
            let success = await equipmentViewModel.createEquipment(
                name: name,
                type: type,
                identifier: identifier,
                status: status
            )
            
            isSubmitting = false
            
            if success {
                dismiss()
            }
        }
    }
}

// MARK: - Edit Equipment Sheet
struct EditEquipmentSheet: View {
    let equipment: Equipment
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var equipmentViewModel: EquipmentViewModel
    
    @State private var name: String
    @State private var type: String
    @State private var status: String
    @State private var isSubmitting = false
    
    init(equipment: Equipment) {
        self.equipment = equipment
        _name = State(initialValue: equipment.name)
        _type = State(initialValue: equipment.type)
        _status = State(initialValue: equipment.status)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Dane sprzętu") {
                    TextField("Nazwa", text: $name)
                    
                    Picker("Typ", selection: $type) {
                        ForEach(Constants.equipmentTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    HStack {
                        Text("Identyfikator:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(equipment.identifier)
                            .fontDesign(.monospaced)
                    }
                    
                    Picker("Status", selection: $status) {
                        ForEach(Constants.EquipmentStatus.allCases, id: \.self) { status in
                            Text(status.displayName).tag(status.rawValue)
                        }
                    }
                }
                
                Section {
                    Button {
                        updateEquipment()
                    } label: {
                        HStack {
                            Spacer()
                            if isSubmitting {
                                ProgressView()
                            } else {
                                Text("Zapisz zmiany")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(name.isEmpty || isSubmitting)
                }
            }
            .navigationTitle("Edytuj sprzęt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func updateEquipment() {
        isSubmitting = true
        
        Task {
            let success = await equipmentViewModel.updateEquipment(
                id: equipment.id,
                name: name,
                type: type,
                status: status
            )
            
            isSubmitting = false
            
            if success {
                dismiss()
            }
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(role: .destructive) {
                        authViewModel.logout()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Wyloguj się")
                            Spacer()
                        }
                    }
                }
                
                Section("Informacje") {
                    HStack {
                        Text("Wersja")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Ustawienia")
        }
    }
}

#Preview {
    AdminView()
        .environmentObject(AuthViewModel())
        .environmentObject(EquipmentViewModel())
}
