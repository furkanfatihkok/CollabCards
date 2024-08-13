//
//  AddCardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct AddCardView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var status = "went well"
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var cardVM: CardViewModel
    var boardID: String
    var boardUsername: String
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                CardTitleInput(title: $title)
                CardStatusPicker(status: $status)
            }
            .navigationTitle("New Card")
            .navigationBarItems(
                leading: CancelButton(dismiss: dismiss),
                trailing: SaveButton(action: saveCard)
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveCard() {
        guard !title.isEmpty else {
            alertMessage = "Cannot be empty."
            showAlert = true
            return
        }
        
        let card = Card(id: UUID(), title: title, status: status, author: boardUsername)
        cardVM.addCard(card, to: boardID) {
            cardVM.fetchCards(for: boardID)
            dismiss()
        }
    }
}

#Preview {
    AddCardView(cardVM: CardViewModel(), boardID: UUID().uuidString, boardUsername: "Furkan")
}
