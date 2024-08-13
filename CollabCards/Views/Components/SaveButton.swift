//
//  Savebutton.swift
//  CollabCards
//
//  Created by FFK on 13.08.2024.
//

import SwiftUI

struct SaveButton: View {
    let action: () -> Void

    var body: some View {
        Button("Save") {
            action()
        }
    }
}
