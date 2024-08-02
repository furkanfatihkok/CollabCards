//
//  ContentView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = BoardViewModel()
    
    var body: some View {
        VStack {
            if viewModel.boards.isEmpty {
                EmptyView(viewModel: viewModel)
            } else {
                HomeView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchBoards()
        }
    }
}

#Preview {
    ContentView()
}
