//
//  ContentView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

//  todo: settings de kaydettiğin işlemlerden sonra boardview'Dan home view'a geçiş sağlaığında settings sıfırlanıyor. Bunu sıfırlattırma.

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

