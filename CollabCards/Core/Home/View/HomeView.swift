//
//  HomeView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading) {
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
            List {
                WorkspaceItemView(color: .blue, title: "deneme")
                WorkspaceItemView(color: .red, title: "Sirius")
                WorkspaceItemView(color: .purple, title: "Belatrix")
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    HomeView()
}
