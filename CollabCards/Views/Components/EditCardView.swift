//  EditCardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct EditCardView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var card: Card
    @State private var showAlert = false
    var viewModel: CardViewModel
    var onSave: (Card) -> Void
    var boardID: String
    var boardUsername: String

    @Binding var title: String
    @Binding var status: String

    var body: some View {
        NavigationView {
            Form {
                Section {
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
                    if title.isEmpty {
                        showAlert = true
                    } else {
                        let updatedCard = Card(id: card.id, title: title, status: status)
                        viewModel.editCard(updatedCard, in: boardID)
                        onSave(updatedCard)
                        dismiss()
                    }
                }
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
