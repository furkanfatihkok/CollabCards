//
//  EditCardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct EditCardView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var card: Card
    var viewModel: CardViewModel
    var onSave: (Card) -> Void
    var boardID: String
    var boardUsername: String

    @Binding var title: String
    @Binding var status: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card Details")) {
                    TextField("Title", text: $title)
                    Picker("Status", selection: $status) {
                        Text("Went Well").tag("went well")
                        Text("To Improve").tag("to improve")
                        Text("Action Items").tag("action items")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Edit Card")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    let updatedCard = Card(id: card.id, title: title, status: status)
                    viewModel.editCard(updatedCard, in: boardID)
                    onSave(updatedCard)
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    EditCardView(
        card: .constant(Card(id: "1", title: "Sample Card", status: "went well")),
        viewModel: CardViewModel(),
        onSave: { _ in },
        boardID: UUID().uuidString,
        boardUsername: "Furkan", 
        title: .constant("Sample Card"),
        status: .constant("went well")
    )
}

