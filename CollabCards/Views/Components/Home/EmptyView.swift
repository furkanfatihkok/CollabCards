//  EmptyView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI
import FirebaseCrashlytics

struct EmptyView: View {
    @State private var showNewBoardSheet = false
    @State private var showQRScanner = false
    @State private var showBoardView = false
    @State private var selectedBoardUUID: UUID?
    @State private var isShareSheetPresented = false
    @ObservedObject var viewModel: BoardViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Image("trello")
                    .resizable()
                    .frame(width: 130, height: 65)
                Spacer()
                Menu {
                    Button(action: {
                        showQRScanner = true
                        Crashlytics.log("Scan or Enter Board ID button tapped")
                    }, label: {
                        Text("Scan or Enter Board ID")
                        Image(systemName: "qrcode.viewfinder")
                    })
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
            
            HStack() {
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
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(activityItems: [URL(string: "https://trello.com")!, "Let's collaborate! Tap to share your Trello profile."])
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showQRScanner) {
                QRScannerAndManualEntryView { board in
                    viewModel.boards.append(board)
                    selectedBoardUUID = board.id
                    showBoardView = true
                }
            }
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
            
            Spacer()
        }
        .sheet(isPresented: $showNewBoardSheet) {
            NewBoardView { newBoard in
                viewModel.addBoard(newBoard)
                Crashlytics.log("New board created in EmptyView with ID: \(newBoard.id)")
            }
        }
        .onAppear {
            viewModel.fetchBoards()
            Crashlytics.log("EmptyView appeared")
        }
        .onChange(of: viewModel.boards.isEmpty) { isEmpty in
            if !isEmpty {
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: HomeView(viewModel: viewModel))
                    Crashlytics.log("Navigated from EmptyView to HomeView as boards are not empty")
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    EmptyView(viewModel: BoardViewModel())
}
