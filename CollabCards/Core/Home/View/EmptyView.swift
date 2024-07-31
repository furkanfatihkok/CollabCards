//
//  EmptyView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI
import SwiftData

struct EmptyView: View {
    @State private var showNewBoardSheet = false
    @Query private var boards: [Board]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image("trello")
                    .resizable()
                    .frame(width: 30, height: 30)
                Spacer()
                Menu {
                    Button(action: {
                        showNewBoardSheet = true
                    }, label: {
                        Text("Create a board")
                        Image(systemName: "doc.on.doc")
                    })
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
                // Action for share profile
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
        .sheet(isPresented: $showNewBoardSheet, content: {
            NewBoardView()
        })
        .onChange(of: boards) { newValue in
            if !newValue.isEmpty {
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: HomeView())
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    EmptyView()
        .modelContainer(for: Board.self)
}
