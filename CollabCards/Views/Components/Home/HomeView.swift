//  HomeView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCrashlytics
import EFQRCode

struct HomeView: View {
    // MARK: - Properties
    
    @State private var showNewBoardSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var boardToDelete: Board?
    @State private var scannedBoardID: String = ""
    @State private var showQRScanner = false
    @State private var showBoardView = false
    @State private var selectedBoard: Board?
    @State private var showBoardInfo = false
    @State private var searchText: String = ""
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @ObservedObject var boardVM = BoardViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HeaderView(showNewBoardSheet: $showNewBoardSheet, showQRScanner: $showQRScanner)
                
                SearchBarView(searchText: $searchText)
                
                Text("YOUR WORKSPACES")
                    .font(.headline)
                    .padding(.horizontal)
                
                List {
                    ForEach(boardVM.boards.filter { searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased())
                    }, id: \.id) { board in
                        HStack {
                            NavigationLink(destination: BoardView(boardID: board.id, username: username)) {
                                WorkspaceItemView(color: .blue, title: board.name)
                            }
                            Spacer()
                            Button(action: {
                                selectedBoard = board
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
            .sheet(item: $selectedBoard) { board in
                BoardInfoView(board: board)
            }
            .sheet(isPresented: $showNewBoardSheet) {
                NewBoardView { newBoard in
                    boardVM.addBoard(newBoard)
                    Crashlytics.log("New board created with ID: \(newBoard.id)")
                }
            }
            .sheet(isPresented: $showQRScanner) {
                QRScannerAndManualEntryView { board, username in
                    if !boardVM.boards.contains(where: { $0.id == board.id }) {
                        boardVM.boards.append(board)
                        self.username = username
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete board?"),
                    message: Text("Once deleted, you can't recover the board or its cards"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let board = boardToDelete {
                            boardVM.deleteBoard(board)
                            Crashlytics.log("Board deleted with ID: \(board.id)")
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                boardVM.fetchBoards()
                Crashlytics.log("HomeView appeared")
                if let savedUsername = UserDefaults.standard.string(forKey: "username") {
                    self.username = savedUsername
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    // MARK: - Functions
    
    private func confirmDeleteBoards(at offsets: IndexSet) {
        if let index = offsets.first {
            boardToDelete = boardVM.boards[index]
            showAlert = true
            Crashlytics.log("Delete board action initiated for board ID: \(boardToDelete?.id ?? UUID())")
        }
    }
}

#Preview {
    HomeView()
}

// MARK: - SearchBarView

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Boards", text: $searchText)
                .padding(.vertical, 10)
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding()
    }
}

// MARK: - WorkspaceItemView

struct WorkspaceItemView: View {
    var color: Color
    var title: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 30, height: 30)
            Text(title)
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

// MARK: - BoardInfoView

struct BoardInfoView: View {
    var board: Board
    
    var qrCode: UIImage? {
        let generator = EFQRCodeGenerator(content: board.id.uuidString)
        if let cgImage = generator.generate() {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Board Information")
                .font(.title)
                .padding()
            
            if let qrCodeImage = qrCode {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
                Text("Board ID: \(board.id)")
                    .font(.body)
                    .foregroundColor(.gray)
                Spacer()
            
            CopyButton(copyText: board.id.uuidString) {
                UIPasteboard.general.string = board.id.uuidString
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}
// MARK: - CopyButton

struct CopyButton: View {
    var copyText: String
    var onCopy: () -> Void
    
    var body: some View {
        Button(action: onCopy) {
            HStack {
                Image(systemName: "doc.on.doc")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                Text("Copy BoardID")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 0.5)
            )
        }
    }
}

