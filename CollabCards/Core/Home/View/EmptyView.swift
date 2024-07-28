//
//  EmptyView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("nodata")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding()
                
                Text("No data available")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EmptyView()
}
