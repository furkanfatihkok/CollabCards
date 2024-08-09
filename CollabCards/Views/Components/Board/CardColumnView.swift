//  CardColumnView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct CardColumnView: View {
    @Binding var cards: [Card]
    let statusFilter: String
    @Binding var allCards: [Card]
    var cardVM: CardViewModel
    var onEdit: (Card) -> Void
    var onDelete: (Card) -> Void
    var boardID: String
    var isAnonymous: Bool
    var board: Board

    var filteredCards: [Card] {
        allCards.filter { $0.status == statusFilter }
    }

    var body: some View {
        VStack {
            ForEach(filteredCards) { card in
                CardView(
                    card: Binding(
                        get: { card },
                        set: { updatedCard in
                            if let index = allCards.firstIndex(where: { $0.id == card.id }) {
                                allCards[index] = updatedCard
                            }
                        }
                    ),
                    allCards: $allCards,
                    onDelete: { card in
                        onDelete(card)
                    },
                    onEdit: { card in
                        onEdit(card)
                    },
                    cardVM: cardVM,
                    boardID: boardID,
                    isAnonymous: isAnonymous,
                    boardUsername: card.author ?? board.usernames?[board.deviceID] ?? "Unknown"
                )
                .onDrag {
                    let data = card.id.data(using: .utf8) ?? Data()
                    return NSItemProvider(item: data as NSSecureCoding, typeIdentifier: UTType.text.identifier)
                }
            }

            if filteredCards.isEmpty {
                Spacer()
                Text("Drag cards here")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(8)
                    .onDrop(of: [UTType.text], delegate: CardDropDelegate(card: nil, allCards: $allCards, cardVM: cardVM, boardID: boardID, status: statusFilter))
            }
        }
        .padding()
        .background(Color.clear)
        .onDrop(of: [UTType.text], delegate: CardDropDelegate(card: nil, allCards: $allCards, cardVM: cardVM, boardID: boardID, status: statusFilter))
    }
}

#Preview {
    CardColumnView(
        cards: .constant([]),
        statusFilter: "todo",
        allCards: .constant([]),
        cardVM: CardViewModel(),
        onEdit: { _ in },
        onDelete: { _ in },
        boardID: UUID().uuidString,
        isAnonymous: false,
        board: Board(id: UUID(), name: "Sample Board", deviceID: "deviceID", participants: ["deviceID"])
    )
}
