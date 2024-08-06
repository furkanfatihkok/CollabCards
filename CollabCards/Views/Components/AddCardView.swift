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
            .navigationTitle("New Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveTask()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveTask() {
        guard !title.isEmpty else {
            alertMessage = "Title cannot be empty."
            showAlert = true
            return
        }
        
        let task = Card(id: UUID().uuidString, title: title, status: status)
        viewModel.addTask(task, to: boardID) {
            viewModel.fetchTasks(for: boardID)
            dismiss()
        }
    }
}

#Preview {
    AddCardView(viewModel: CardViewModel(), boardID: UUID().uuidString)
}