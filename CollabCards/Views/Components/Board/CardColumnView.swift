//
//  CardColumnView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct CardColumnView: View {
    // MARK: - Properties
    
    @Binding var cards: [Card]
    @Binding var allCards: [Card]
    let statusFilter: String
    var cardVM: CardViewModel
    var onEdit: (Card) -> Void
    var onDelete: (Card) -> Void
    var boardID: String
    var board: Board
    var isAuthorVisible: Bool
    var isDateVisible: Bool

    var filteredCards: [Card] {
        allCards.filter { $0.status == statusFilter }
    }
    // MARK: - Body
    
    var body: some View {
        VStack {
            FilteredCardListView(
                allCards: $allCards, filteredCards: filteredCards,
                onEdit: onEdit,
                onDelete: onDelete,
                cardVM: cardVM,
                boardID: boardID,
                board: board,
                isAuthorVisible: isAuthorVisible,
                isDateVisible: isDateVisible
            )

            if filteredCards.isEmpty {
                EmptyColumnView(allCards: $allCards, statusFilter: statusFilter, cardVM: cardVM, boardID: boardID)
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
        allCards: .constant([]), statusFilter: "todo",
        cardVM: CardViewModel(),
        onEdit: { _ in },
        onDelete: { _ in },
        boardID: UUID().uuidString,
        board: Board(id: UUID(), name: "Sample Board", deviceID: "deviceID", participants: ["deviceID"]),
        isAuthorVisible: true,
        isDateVisible: true
    )
}

// MARK: - FilteredCardListView

struct FilteredCardListView: View {
    @Binding var allCards: [Card]
    var filteredCards: [Card]
    var onEdit: (Card) -> Void
    var onDelete: (Card) -> Void
    var cardVM: CardViewModel
    var boardID: String
    var board: Board
    var isAuthorVisible: Bool
    var isDateVisible: Bool

    var body: some View {
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
                onDelete: onDelete,
                onEdit: onEdit,
                cardVM: cardVM,
                boardID: boardID,
                boardUsername: card.author ?? board.usernames?[board.deviceID] ?? "Unknown",
                isAuthorVisible: isAuthorVisible,
                isDateVisible: isDateVisible
            )
            .onDrag {
                let data = card.id.uuidString.data(using: .utf8) ?? Data()
                return NSItemProvider(item: data as NSSecureCoding, typeIdentifier: UTType.text.identifier)
            }
        }
    }
}
// MARK: - EmptyColumnView

struct EmptyColumnView: View {
    @Binding var allCards: [Card]
    var statusFilter: String
    var cardVM: CardViewModel
    var boardID: String

    var body: some View {
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
