//  CardDropDelegate.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct CardDropDelegate: DropDelegate {
    let card: Card?
    @Binding var allCards: [Card]
    @ObservedObject var cardVM: CardViewModel
    let boardID: String
    let status: String

    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [UTType.text]).first else { return false }

        item.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (data, error) in
            guard let data = data as? Data, let id = String(data: data, encoding: .utf8) else { return }

            DispatchQueue.main.async {
                if let draggedCardIndex = allCards.firstIndex(where: { $0.id == id }) {
                    allCards[draggedCardIndex].status = status
                    cardVM.moveCard(allCards[draggedCardIndex], toStatus: status, in: boardID)
                }
            }
        }
        return true
    }
}
