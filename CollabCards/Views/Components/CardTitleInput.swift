//
//  CardTitleInput.swift
//  CollabCards
//
//  Created by FFK on 13.08.2024.
//

import SwiftUI

struct CardTitleInput: View {
    @Binding var title: String
    
    var body: some View {
        TextField("Type something...", text: $title)
    }
}
