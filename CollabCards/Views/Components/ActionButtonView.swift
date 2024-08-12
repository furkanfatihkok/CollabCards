//
//  ActionButtonView.swift
//  CollabCards
//
//  Created by FFK on 12.08.2024.
//

import SwiftUI

struct ActionButtonView: View {
    let action: () -> Void
    let label: String
    let systemImage: String
    let foregroundColor: Color = .gray
    
    var body: some View {
        Button(action: action) {
            Label(label, systemImage: systemImage)
                .foregroundColor(foregroundColor)
        }
    }
}
#Preview {
    ActionButtonView(action: { /* Reset votes logic */ }, label: "Reset all votes", systemImage: "arrow.counterclockwise")
}
