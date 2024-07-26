//
//  TaskCardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct TaskCardView: View {
    @Binding var task: Board
    @Binding var allTasks: [Board]
    var onDelete: (Board) -> Void
    var onEdit: (Board) -> Void
    var viewModel: BoardViewModel

    @State private var showEditSheet = false

    var body: some View {
        VStack {
            Text(task.title)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .background(backgroundColor(for: task.status))
                .cornerRadius(8)
                .shadow(radius: 3)
                .onDrag {
                    let data = task.id?.data(using: .utf8) ?? Data()
                    let provider = NSItemProvider(item: data as NSSecureCoding, typeIdentifier: UTType.text.identifier)
                    return provider
                }
                .onDrop(of: [UTType.text], delegate: TaskDropDelegate(task: task, allTasks: $allTasks, viewModel: viewModel))

            HStack {
                Button(action: { showEditSheet.toggle() }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showEditSheet) {
                    EditTaskView(
                        task: $task,
                        viewModel: viewModel,
                        onSave: { updatedTask in
                            viewModel.editTask(updatedTask)
                            showEditSheet = false
                        }
                    )
                }

                Button(action: { onDelete(task) }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }

    func backgroundColor(for status: String) -> Color {
        switch status {
        case "todo":
            return Color.red
        case "progress":
            return Color.yellow
        case "done":
            return Color.green
        default:
            return Color.gray
        }
    }
}
