//
//  HistoryView.swift
//  KiteEquipmentApp
//
//  Widok historii użycia sprzętu
//

import SwiftUI

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var history: [HistoryEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedType: String?
    @Published var selectedInstructor: String?
    
    private let networkService = NetworkService.shared
    
    var filteredHistory: [HistoryEntry] {
        history.filter { entry in
            let matchesType = selectedType == nil || entry.equipmentType == selectedType
            let matchesInstructor = selectedInstructor == nil || entry.instructor == selectedInstructor
            
            return matchesType && matchesInstructor
        }
    }
    
    var uniqueInstructors: [String] {
        Array(Set(history.map { $0.instructor })).sorted()
    }
    
    func loadHistory() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedHistory = try await networkService.fetchHistory()
            self.history = fetchedHistory
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.filteredHistory.isEmpty {
                    EmptyHistoryView()
                } else {
                    List {
                        ForEach(viewModel.filteredHistory) { entry in
                            HistoryRow(entry: entry)
                        }
                    }
                }
            }
            .navigationTitle("Historia")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilters.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.loadHistory()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                HistoryFiltersSheet(viewModel: viewModel)
            }
            .task {
                await viewModel.loadHistory()
            }
        }
    }
}

// MARK: - History Row
struct HistoryRow: View {
    let entry: HistoryEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.equipmentName)
                    .font(.headline)
                
                Spacer()
                
                Text(entry.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "person.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(entry.instructor)
                    .font(.subheadline)
                
                Spacer()
                
                Text(entry.equipmentType)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
            }
            
            HStack {
                Image(systemName: "clock.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(entry.formattedStartTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if entry.endTime != nil {
                    Text(entry.durationString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("W użyciu")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Filters Sheet
struct HistoryFiltersSheet: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Typ sprzętu") {
                    Button {
                        viewModel.selectedType = nil
                    } label: {
                        HStack {
                            Text("Wszystkie")
                            Spacer()
                            if viewModel.selectedType == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    ForEach(Constants.equipmentTypes, id: \.self) { type in
                        Button {
                            viewModel.selectedType = type
                        } label: {
                            HStack {
                                Text(type)
                                Spacer()
                                if viewModel.selectedType == type {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section("Instruktor") {
                    Button {
                        viewModel.selectedInstructor = nil
                    } label: {
                        HStack {
                            Text("Wszyscy")
                            Spacer()
                            if viewModel.selectedInstructor == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    ForEach(viewModel.uniqueInstructors, id: \.self) { instructor in
                        Button {
                            viewModel.selectedInstructor = instructor
                        } label: {
                            HStack {
                                Text(instructor)
                                Spacer()
                                if viewModel.selectedInstructor == instructor {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        viewModel.selectedType = nil
                        viewModel.selectedInstructor = nil
                    } label: {
                        HStack {
                            Spacer()
                            Text("Wyczyść filtry")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Filtry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gotowe") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Empty State
struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.xmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Brak historii")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Historia użycia sprzętu pojawi się tutaj")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HistoryView()
}
