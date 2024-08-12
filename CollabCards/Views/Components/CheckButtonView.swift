//
//  CheckButtonView.swift
//  CollabCards
//
//  Created by FFK on 12.08.2024.
//

import SwiftUI

struct CheckButtonView: View {
    @Binding var isChecked: Bool
    let title: String
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }, label: {
            HStack {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(isChecked ? .blue : .gray)
                Text(title)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical, 4)
        })
    }
}

#Preview {
    CheckButtonView(isChecked: .constant(false), title: "Disable")
}
