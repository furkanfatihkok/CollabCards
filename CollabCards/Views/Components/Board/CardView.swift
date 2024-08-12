//  CardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct CardView: View {
    @Binding var card: Card
    @Binding var allCards: [Card]
    
    var onDelete: (Card) -> Void
    var onEdit: (Card) -> Void
    var cardVM: CardViewModel
    var boardID: String
    var boardUsername: String
    var isAuthorVisible: Bool
    var isDateVisible: Bool
    
    @State private var showEditSheet = false
    
    var body: some View {
        HStack {
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
            .background(backgroundColor(for: card.status))
            .cornerRadius(8)
            .shadow(radius: 3)
            .onTapGesture {
                showEditSheet.toggle()
            }
            .onDrag {
                let data = card.id.data(using: .utf8) ?? Data()
                let provider = NSItemProvider(item: data as NSSecureCoding, typeIdentifier: UTType.text.identifier)
                return provider
            }
            
            Button(action: { onDelete(card) }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .padding(.trailing, 5)
        }
        .sheet(isPresented: $showEditSheet) {
            EditCardView(
                card: $card,
                cardVM: cardVM,
                onSave: { updatedCard in
                    cardVM.editCard(updatedCard, in: boardID)
                    showEditSheet = false
                }, boardID: boardID,
                boardUsername: card.author ?? boardUsername,
                title: $card.title,
                status: $card.status
            )
        }
    }
    
    func backgroundColor(for status: String) -> Color {
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
    
    func dateFormatted(date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }
}
