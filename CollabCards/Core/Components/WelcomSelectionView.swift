//
//  WelcomSelectionView.swift
//  CollabCards
//
//  Created by FFK on 25.07.2024.
//

import SwiftUI

struct WelcomSelectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome Furkan")
                .font(.title)
                .fontWeight(.bold)
            Text("Let us create new retrospective. What shall we call it?")
                .font(.subheadline)
        }
        .padding(.vertical)
    }
}

#Preview {
    WelcomSelectionView()
}
