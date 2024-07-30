//
//  EditTaskView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

/*
 Sadece bir sheet aç ve bir tane textField olsun
 sağ aşağıda da save olsun sol aşağıda cancel.
 */

struct EditTaskView: View {
    @Binding var task: Card
    var viewModel: BoardViewModel
    var onSave: (Card) -> Void
    
    @State private var title: String
    @State private var description: String
    @State private var status: String

    init(task: Binding<Card>, viewModel: BoardViewModel, onSave: @escaping (Card) -> Void) {
        self._task = task
        self.viewModel = viewModel
        self.onSave = onSave
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
                }

                Button("Save") {
                    let updatedTask = Card(id: task.id, title: title, description: description, status: status)
                    onSave(updatedTask)
                }
            }
            .navigationTitle("Edit Task")
        }
    }
}

#Preview {
    let sampleTask = Card(id: "1", title: "Sample Task", description: "Sample Description", status: "todo")
    let sampleViewModel = BoardViewModel()
    return EditTaskView(task: .constant(sampleTask), viewModel: sampleViewModel) { updatedTask in
        print("Task saved: \(updatedTask)")
    }
}
