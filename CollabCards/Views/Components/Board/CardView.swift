//
//  CardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct CardView: View {
    //MARK: - Properties
    
    @Binding var card: Card
    @Binding var allCards: [Card]
    @State private var showEditSheet = false
    @State private var isHovered: Bool = false
    
    var onDelete: (Card) -> Void
    var onEdit: (Card) -> Void
    var cardVM: CardViewModel
    var boardID: String
    var boardUsername: String
    var isAuthorVisible: Bool
    var isDateVisible: Bool
    var isAddEditCardsDisabled: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            CardDetailsView(card: card, boardUsername: boardUsername, isAuthorVisible: isAuthorVisible, isDateVisible: isDateVisible)
                .background(backgroundColor(for: card.status))
                .cornerRadius(8)
                .shadow(radius: 3)
                .onTapGesture {
                    if !isAddEditCardsDisabled {
                        showEditSheet.toggle()
                    }
                }
                .onDrag {
                    dragProvider(for: card.id)
                }
            
            DeleteButton(onDelete: { onDelete(card) })
                .padding(.trailing, 5)
        }
        .sheet(isPresented: $showEditSheet) {
            if !isAddEditCardsDisabled {
                EditCardView(
                    card: $card,
                    title: $card.title,
                    status: $card.status,
                    cardVM: cardVM,
                    onSave: { updatedCard in
                        cardVM.editCard(updatedCard, in: boardID)
                        showEditSheet = false
                    },
                    boardID: boardID,
                    boardUsername: boardUsername
                )
            }
        }
    }
    
    // MARK: - Functions
    
    private func backgroundColor(for status: String) -> Color {
        switch status {
        case "went well":
            return Color(red: 0.0, green: 100.0/255.0, blue: 0.0)
        case "to improve":
            return Color(red: 255.0/255.0, green: 69.0/255.0, blue: 0.0)
        case "action items":
            return Color.purple
        default:
            return Color.gray
        }
    }
    
    private func dragProvider(for id: UUID) -> NSItemProvider {
        let data = id.uuidString.data(using: .utf8) ?? Data()
        return NSItemProvider(item: data as NSSecureCoding, typeIdentifier: UTType.text.identifier)
    }
}

#Preview {
    CardView(
        card: .constant(Card(id: UUID(), title: "Sample Card", status: "went well", author: "FFK", date: Date())),
        allCards: .constant([]),
        onDelete: { _ in },
        onEdit: { _ in },
        cardVM: CardViewModel(),
        boardID: UUID().uuidString,
        boardUsername: "FFK",
        isAuthorVisible: true,
        isDateVisible: true, 
        isAddEditCardsDisabled: true
    )
}

//MARK: - CardDetailsView

struct CardDetailsView: View {
    var card: Card
    var boardUsername: String
    var isAuthorVisible: Bool
    var isDateVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(card.title)
                .foregroundStyle(.white)
                .padding(.bottom, 2)
            
            if isAuthorVisible {
                Text(card.author ?? boardUsername)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            if isDateVisible {
                Text(dateFormatted(date: card.date))
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func dateFormatted(date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }
}

//MARK: - DeleteButton

struct DeleteButton: View {
    var onDelete: () -> Void
    
    var body: some View {
        Button(action: onDelete) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
    }
}
