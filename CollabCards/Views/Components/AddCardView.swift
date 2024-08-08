//
//  AddCardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: CardViewModel
    var boardID: String
    var boardUsername: String

    @State private var title = ""
    @State private var status = "went well"
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                Picker("Status", selection: $status) {
                    Text("Went Well").tag("went well")
                    Text("To Improve").tag("to improve")
                    Text("Action Items").tag("action items")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("New Card")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveCard()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveCard() {
        guard !title.isEmpty else {
            alertMessage = "Title cannot be empty."
            showAlert = true
            return
        }
        
        let card = Card(id: UUID().uuidString, title: title, status: status, author: boardUsername)
        viewModel.addCard(card, to: boardID) {
            viewModel.fetchCards(for: boardID)
            dismiss()
        }
    }
}

#Preview {
    AddCardView(viewModel: CardViewModel(), boardID: UUID().uuidString, boardUsername: "Furkan")
}
