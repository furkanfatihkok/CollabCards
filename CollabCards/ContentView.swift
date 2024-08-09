//
//  ContentView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var boardVM = BoardViewModel()
    
    var body: some View {
        VStack {
            if boardVM.boards.isEmpty {
                EmptyView(boardVM: boardVM)
            } else {
                HomeView(boardVM: boardVM)
            }
        }
        .onAppear {
            boardVM.fetchBoards()
        }
    }
}

#Preview {
    ContentView()
}
