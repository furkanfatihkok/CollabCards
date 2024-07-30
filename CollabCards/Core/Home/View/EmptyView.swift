//
//  EmptyView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "trello")//Logo eklenecek buraya
                    .resizable()
                    .frame(width: 30, height: 30)
                Spacer()
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            
            HStack(spacing: 20) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
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
            
            Image(systemName: "person.crop.circle")
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
                // Action for create board
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
        .navigationBarHidden(true)
    }
}

#Preview {
    EmptyView()
}
