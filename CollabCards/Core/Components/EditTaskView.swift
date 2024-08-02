//
//  EditTaskView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var task: Card
    var viewModel: CardViewModel
    var onSave: (Card) -> Void
    var boardID: String
    
    @Binding var title: String
    @Binding var description: String
    @Binding var status: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    Picker("Status", selection: $status) {
                        Text("To Do").tag("todo")
                        Text("In Progress").tag("progress")
                        Text("Done").tag("done")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Button("Save") {
                    let updatedTask = Card(id: task.id, title: title, description: description, status: status)
                    viewModel.editTask(updatedTask, in: boardID)
                    onSave(updatedTask)
                    dismiss()
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
