//
//  HomeView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var showNewBoardSheet = false
    @Query private var boards: [Board]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "trello")//Logo eklenecek buraya
                    .resizable()
                    .frame(width: 30, height: 30)
                Spacer()
                Menu {
                    Button(action: {
                        showNewBoardSheet = true
                    }) {
                        Text("Create a board")
                        Image(systemName: "doc.on.doc")
                    }
                    Button(action: {
                        // Browse templates action
                    }) {
                        Text("Create a card")
                        Image(systemName: "square.on.square")
                    }
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Boards", text: .constant(""))
                    .padding(.vertical , 10)
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding()
            Text("YOUR WORKSPACES")
                .font(.headline)
                .padding(.horizontal)
            List(boards) { board in
                WorkspaceItemView(color: .blue, title: board.name)
            }
            .listStyle(PlainListStyle())
        }
        .sheet(isPresented: $showNewBoardSheet, content: {
            NewBoardView()
        })
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Board.self)
}
