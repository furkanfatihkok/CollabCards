//
//  HomeView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @State private var showNewBoardSheet = false
    @State private var showAlert = false
    @State private var boardToDelete: Board?
    @State private var scannedBoardID: String = ""
    @State private var showQRScanner = false
    @State private var showBoardView = false
    @State private var selectedBoardUUID: UUID?
    @State private var showBoardInfo = false
    @ObservedObject var viewModel = BoardViewModel()
    
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
                    ForEach(viewModel.boards, id: \.id) { board in
                        HStack {
                            NavigationLink(destination: BoardView(boardID: board.id)) {
                                WorkspaceItemView(color: .blue, title: board.name)
                            }
                            Spacer()
                            Button(action: {
                                selectedBoardUUID = board.id
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
                NewBoardView { newBoard in
                    selectedBoardUUID = newBoard.id
                    viewModel.addBoard(newBoard)
                }
            }
            .sheet(isPresented: $showBoardInfo) {
                if let boardUUID = selectedBoardUUID {
                    if let board = viewModel.boards.first(where: { $0.id == boardUUID }) {
                        BoardInfoView(board: board)
                    }
                }
            }
            .sheet(isPresented: $showQRScanner) {
                QRScannerView { scannedCode in
                    if let scannedUUID = UUID(uuidString: scannedCode) {
                        self.selectedBoardUUID = scannedUUID
                        self.showBoardView = true
                        self.showQRScanner = false
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Board?"),
                    message: Text("Once deleted, you can't recover the board or its cards."),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Delete")) {
                        if let board = boardToDelete {
                            viewModel.deleteBoard(board)
                        }
                    }
                )
            }
            .onAppear {
                viewModel.fetchBoards()
            }
        }
    }
    
    private func confirmDeleteBoards(at offsets: IndexSet) {
        if let index = offsets.first {
            boardToDelete = viewModel.boards[index]
            showAlert = true
        }
    }
}

#Preview {
    HomeView()
}
