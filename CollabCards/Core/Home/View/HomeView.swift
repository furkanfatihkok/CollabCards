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
    @State private var showAlert = false
    @State private var boardToDelete: Board?
    @Environment(\.modelContext) private var context: ModelContext
    @Query private var boards: [Board]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "trello") // Logo eklenecek buraya
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
                        .padding(.vertical, 10)
                }
                .padding(.horizontal)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
                Text("YOUR WORKSPACES")
                    .font(.headline)
                    .padding(.horizontal)
                
                List {
                    ForEach(boards, id: \.id) { board in
                        NavigationLink(destination: BoardView(ideateDuration: 15, discussDuration: 20)) {
                            WorkspaceItemView(color: .blue, title: board.name)
                        }
                    }
                    .onDelete(perform: confirmDeleteBoards)
                }
                .listStyle(PlainListStyle())
            }
            .sheet(isPresented: $showNewBoardSheet, content: {
                NewBoardView()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Board?"),
                    message: Text("Once deleted, you can't recover the board or its cards."),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Delete")) {
                        if let board = boardToDelete {
                            deleteBoard(board)
                        }
                    }
                )
        }
        }
    }
    
    private func confirmDeleteBoards(at offsets: IndexSet) {
        if let index = offsets.first {
            boardToDelete = boards[index]
            showAlert = true
        }
    }
    
    private func deleteBoard(_ board: Board) {
        context.delete(board)
        do {
            try context.save()
        } catch {
            print("Error deleting board: \(error)")
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Board.self)
}
