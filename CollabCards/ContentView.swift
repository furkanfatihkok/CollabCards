//
//  ContentView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            EmptyView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            RetroView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add retro")
                }
            Text("Notifications")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    ContentView()
}
