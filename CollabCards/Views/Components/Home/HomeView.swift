//  HomeView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCrashlytics

struct HomeView: View {
    @State private var showNewBoardSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""
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
                    Spacer()
                    Image("trello")
                        .resizable()
                        .frame(width: 130, height: 65)
                    Spacer()
                    Menu {
                        Button(action: {
                            showNewBoardSheet = true
                            Crashlytics.log("Create a board button tapped")
                        }) {
                            Text("Create a board")
                            Image(systemName: "doc.on.doc")
                        }
                        Button(action: {
                            showQRScanner = true
                            Crashlytics.log("Scan or Enter Board ID button tapped")
                        }) {
                            Text("Scan or Enter Board ID")
                            Image(systemName: "qrcode.viewfinder")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
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
                                Crashlytics.log("Board info button tapped for board ID: \(board.id)")
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
                    Crashlytics.log("New board created with ID: \(newBoard.id)")
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
                QRScannerAndManualEntryView { board in
                    viewModel.boards.append(board)
                    selectedBoardUUID = board.id
                    showBoardView = true
                }
            }
//            .background(
//                NavigationLink(destination: BoardView(boardID: selectedBoardUUID ?? UUID()), isActive: $showBoardView) {
//                    //                    EmptyView()
//                }
//            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete board?"),
                    message: Text("Once deleted, you can't recover the board or its cards"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let board = boardToDelete {
                            viewModel.deleteBoard(board)
                            Crashlytics.log("Board deleted with ID: \(board.id)")
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                viewModel.fetchBoards()
                Crashlytics.log("HomeView appeared")
            }
        }
    }
    
    private func confirmDeleteBoards(at offsets: IndexSet) {
        if let index = offsets.first {
            boardToDelete = viewModel.boards[index]
            showAlert = true
            Crashlytics.log("Delete board action initiated for board ID: \(boardToDelete?.id ?? UUID())")
        }
    }
}

#Preview {
    HomeView()
}

