//
//  StatusBadge.swift
//  KiteEquipmentApp
//
//  Badge statusu sprzętu
//

import SwiftUI

struct StatusBadge: View {
    let status: Constants.EquipmentStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(status.displayName)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(statusColor.opacity(0.15))
        .cornerRadius(12)
    }
    
    private var statusColor: Color {
        switch status {
        case .available:
            return .green
        case .inUse:
            return .orange
        case .service:
            return .red
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        StatusBadge(status: .available)
        StatusBadge(status: .inUse)
        StatusBadge(status: .service)
    }
    .padding()
}
