//
//  EditTaskView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct EditCardView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var task: Card
    var viewModel: CardViewModel
    var onSave: (Card) -> Void
    var boardID: String
    
    @Binding var title: String
    @Binding var status: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    Picker("Status", selection: $status) {
                        Text("Went Well").tag("went well")
                        Text("To Improve").tag("to improve")
                        Text("Action Items").tag("action items")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    let updatedTask = Card(id: task.id, title: title, status: status)
                    viewModel.editTask(updatedTask, in: boardID)
                    onSave(updatedTask)
                    dismiss()
                }
            )
        }
    }
}
