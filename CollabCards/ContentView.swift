//
//  ContentView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var hasData: Bool = false
    
    var body: some View {
        VStack {
            if hasData {
                HomeView()
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView()
}
