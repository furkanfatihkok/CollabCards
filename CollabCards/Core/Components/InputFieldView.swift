//
//  InputFieldView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct InputFieldView: View {
    @Binding var retroName: String
    
    var body: some View {
        TextField("Enter your name", text: $retroName)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(5)
            .padding(.horizontal)
    }
}

#Preview {
    InputFieldView(retroName: .constant(""))
}
