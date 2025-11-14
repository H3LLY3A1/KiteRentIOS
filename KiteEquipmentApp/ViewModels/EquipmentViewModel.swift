//
//  EquipmentViewModel.swift
//  KiteEquipmentApp
//
//  ViewModel dla zarządzania sprzętem
//

import Foundation

@MainActor
class EquipmentViewModel: ObservableObject {
    @Published var equipment: [Equipment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedType: String?
    @Published var selectedStatus: String?
    
    private let networkService = NetworkService.shared
    
    var filteredEquipment: [Equipment] {
        equipment.filter { item in
            let matchesSearch = searchText.isEmpty ||
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.identifier.localizedCaseInsensitiveContains(searchText)
            
            let matchesType = selectedType == nil || item.type == selectedType
            let matchesStatus = selectedStatus == nil || item.status == selectedStatus
            
            return matchesSearch && matchesType && matchesStatus
        }
    }
    
    func loadEquipment() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedEquipment = try await networkService.fetchEquipment()
            self.equipment = fetchedEquipment
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func startUse(equipmentId: String, instructor: String) async -> Bool {
        do {
            let updated = try await networkService.startUse(equipmentId: equipmentId, instructor: instructor)
            
            // Update local array
            if let index = equipment.firstIndex(where: { $0.id == equipmentId }) {
                equipment[index] = updated
            }
            
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    func endUse(equipmentId: String) async -> Bool {
        do {
            let updated = try await networkService.endUse(equipmentId: equipmentId)
            
            // Update local array
            if let index = equipment.firstIndex(where: { $0.id == equipmentId }) {
                equipment[index] = updated
            }
            
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    func createEquipment(name: String, type: String, identifier: String, status: String) async -> Bool {
        do {
            let newEquipment = try await networkService.createEquipment(
                name: name,
                type: type,
                identifier: identifier,
                status: status
            )
            
            // Add to local array
            equipment.append(newEquipment)
            
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    func updateEquipment(id: String, name: String, type: String, status: String) async -> Bool {
        do {
            let updated = try await networkService.updateEquipment(
                id: id,
                name: name,
                type: type,
                status: status
            )
            
            // Update local array
            if let index = equipment.firstIndex(where: { $0.id == id }) {
                equipment[index] = updated
            }
            
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    func deleteEquipment(id: String) async -> Bool {
        do {
            try await networkService.deleteEquipment(id: id)
            
            // Remove from local array
            equipment.removeAll { $0.id == id }
            
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}
