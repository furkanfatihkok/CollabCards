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
    @State private var description = ""
    @State private var status = "went well"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
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
                    guard !title.isEmpty, !description.isEmpty else {
                        print("Title or Description is empty")
                        return
                    }
                    let task = Card(id: UUID().uuidString, title: title, description: description, status: status)
                    viewModel.addTask(task, to: boardID) {
                        viewModel.fetchTasks(for: boardID)
                        dismiss()
                    }
                }
            )
        }
    }
}

#Preview {
    AddCardView(viewModel: CardViewModel(), boardID: UUID().uuidString)
}
