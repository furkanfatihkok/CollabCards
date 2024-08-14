//
//  EditCardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct EditCardView: View {
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var card: Card
    @Binding var title: String
    @Binding var status: String
    
    @State private var showAlert = false
    
    var cardVM: CardViewModel
    var onSave: (Card) -> Void
    var boardID: String
    var boardUsername: String
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            EditCardForm(
                title: $title,
                status: $status
            )
            .navigationTitle("Edit Card")
            .navigationBarItems(
                leading: CancelButton(dismiss: dismiss),
                trailing: SaveButton(action: saveCard)
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("Title cannot be empty."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    // MARK: - Functions
    
    private func saveCard() {
        if title.isEmpty {
            showAlert = true
        } else {
            let updatedCard = Card(id: card.id, title: title, status: status)
            cardVM.editCard(updatedCard, in: boardID)
            onSave(updatedCard)
            dismiss()
        }
    }
}

#Preview {
    let sampleCard = Card(id: UUID(), title: "Sample Card", status: "went well")
    let cardViewModel = CardViewModel()
    
    return EditCardView(
        card: .constant(sampleCard),
        title: .constant(sampleCard.title),
        status: .constant(sampleCard.status),
        cardVM: cardViewModel,
        onSave: { _ in },
        boardID: UUID().uuidString,
        boardUsername: "FFK"
    )
}

// MARK: - EditCardForm

struct EditCardForm: View {
    @Binding var title: String
    @Binding var status: String
    
    var body: some View {
        Form {
            Section {
                CardTitleInput(title: $title)
            }
        }
    }
}


