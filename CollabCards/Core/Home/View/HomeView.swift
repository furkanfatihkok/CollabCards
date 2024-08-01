//
//  HomeView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI
import SwiftData
import AVFoundation

struct HomeView: View {
    @State private var showNewBoardSheet = false
    @State private var showAlert = false
    @State private var boardToDelete: Board?
    @Environment(\.modelContext) private var context: ModelContext
    @Query private var boards: [Board]
    @State private var scannedBoardID: String = ""
    @State private var showQRScanner = false
    @State private var showBoardView = false
    @State private var selectedBoard: Board?
    @State private var showBoardInfo = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Image("trello")
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
                            showQRScanner = true
                        }) {
                            Text("Scan QR Code")
                            Image(systemName: "qrcode.viewfinder")
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
                        HStack {
                            NavigationLink(destination: BoardView(ideateDuration: 15, discussDuration: 20, board: board)) {
                                WorkspaceItemView(color: .blue, title: board.name)
                            }
                            Spacer()
                            Button(action: {
                                selectedBoard = board
                                showBoardInfo = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onDelete(perform: confirmDeleteBoards)
                }
                .listStyle(PlainListStyle())
            }
            .sheet(isPresented: $showNewBoardSheet) {
                NewBoardView()
            }
            .sheet(isPresented: $showQRScanner) {
                QRScannerView { scannedCode in
                    self.scannedBoardID = scannedCode
                    self.showBoardView = true
                    self.showQRScanner = false
                }
            }
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
            .sheet(isPresented: $showBoardInfo) {
                if let board = selectedBoard {
                    NavigationView {
                        BoardInfoView(board: board)
                    }
                }
            }
        }
    }
    
    private func boardFromID(_ id: String) -> Board? {
        return boards.first { $0.id.uuidString == id }
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
