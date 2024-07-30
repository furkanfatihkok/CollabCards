//
//  WorkspaceItemView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI

struct WorkspaceItemView: View {
    var color: Color
    var title: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 30, height: 30)
            Text(title)
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    WorkspaceItemView(color: Color.gray, title: "Deneme")
}
