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
    
    @State private var title: String
    @State private var description: String
    @State private var status: String

    init(task: Binding<Card>, viewModel: CardViewModel, boardID: String, onSave: @escaping (Card) -> Void) {
        self._task = task
        self.viewModel = viewModel
        self.onSave = onSave
        self.boardID = boardID
        _title = State(initialValue: task.wrappedValue.title)
        _description = State(initialValue: task.wrappedValue.description)
        _status = State(initialValue: task.wrappedValue.status)
    }

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

#Preview {
    let sampleTask = Card(id: "1", title: "Sample Task", description: "Sample Description", status: "todo")
    let sampleViewModel = CardViewModel()
    return EditTaskView(task: .constant(sampleTask), viewModel: sampleViewModel, boardID: UUID().uuidString) { updatedTask in
        print("Task saved: \(updatedTask)")
    }
}
