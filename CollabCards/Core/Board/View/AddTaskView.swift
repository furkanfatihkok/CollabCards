//
//  AddTaskView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var viewModel: BoardViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var status = "todo"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                Picker("Status", selection: $status) {
                    Text("To Do").tag("todo")
                    Text("In Progress").tag("progress")
                    Text("Done").tag("done")
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard !title.isEmpty, !description.isEmpty else {
                            print("Title or Description is empty")
                            return
                        }
                        let task = Board(id: UUID().uuidString, title: title, description: description, status: status)
                        viewModel.addTask(task)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
