//  EmptyView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI
import FirebaseCrashlytics

struct EmptyView: View {
    // MARK: - Properties
    
    @State private var showNewBoardSheet = false
    @State private var showQRScanner = false
    @State private var showBoardView = false
    @State private var selectedBoardUUID: UUID?
    @State private var isShareSheetPresented = false
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @ObservedObject var boardVM: BoardViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView(showNewBoardSheet: .constant(false), showQRScanner: $showQRScanner)
            
            ProfileSharingView(isShareSheetPresented: $isShareSheetPresented)
            
            CreateBoardView(showNewBoardSheet: $showNewBoardSheet)
            
            Spacer()
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(activityItems: [URL(string: "https://trello.com")!, "Let's collaborate! Tap to share your Trello profile."])
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showQRScanner) {
            QRScannerAndManualEntryView { board, username in
                boardVM.boards.append(board)
                selectedBoardUUID = board.id
                self.username = username
                showBoardView = true
            }
        }
        .sheet(isPresented: $showNewBoardSheet) {
            NewBoardView { newBoard in
                boardVM.addBoard(newBoard)
                Crashlytics.log("New board created in EmptyView with ID: \(newBoard.id)")
            }
        }
        .onAppear {
            boardVM.fetchBoards()
            Crashlytics.log("EmptyView appeared")
            if let savedUsername = UserDefaults.standard.string(forKey: "username") {
                self.username = savedUsername
            }
        }
        .onChange(of: boardVM.boards.isEmpty) { isEmpty in
            if !isEmpty {
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: HomeView(boardVM: boardVM))
                    Crashlytics.log("Navigated from EmptyView to HomeView as boards are not empty")
                }
            }
        }
    }
}

#Preview {
    EmptyView(boardVM: BoardViewModel())
}

// MARK: - ProfileSharingView

struct ProfileSharingView: View {
    @Binding var isShareSheetPresented: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image("person1")
                    .resizable()
                    .frame(width: 80, height: 80)
                Image("person2")
                    .resizable()
                    .frame(width: 80, height: 80)
                Image("person3")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .padding(.top, 50)
            
            Text("Tell your team you’re here!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Share your profile so collaborators can add you to Workspaces and boards.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                isShareSheetPresented = true
                Crashlytics.log("Share your Trello profile button tapped in EmptyView")
            }) {
                Text("Share your Trello profile")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - CreateBoardView

struct CreateBoardView: View {
    @Binding var showNewBoardSheet: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Image("person1")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.top, 30)
            
            Text("Solo for now?")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Get started with a board and share it with collaborators later.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showNewBoardSheet = true
                Crashlytics.log("Create your first CollabBoards button tapped in EmptyView")
            }) {
                Text("Create your first CollabBoards")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
    }
}


