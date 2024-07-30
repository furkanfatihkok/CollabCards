//
//  ContentView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var boards: [Board]
    
    var body: some View {
        VStack {
            if boards.isEmpty {
                HomeView()
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Board.self)
}
