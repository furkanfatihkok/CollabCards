//
//  CancelButton.swift
//  CollabCards
//
//  Created by FFK on 13.08.2024.
//

import SwiftUI

struct CancelButton: View {
    let dismiss: DismissAction

    var body: some View {
        Button("Cancel") {
            dismiss()
        }
    }
}
