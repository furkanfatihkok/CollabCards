//
//  TaskColumnView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct TaskColumnView: View {
    let title: String
    @Binding var tasks: [Board]
    let statusFilter: String
    @Binding var allTasks: [Board]
    var viewModel: BoardViewModel
    var onEdit: (Board) -> Void
    var onDelete: (Board) -> Void
    
    var filteredTasks: [Board] {
        allTasks.filter { $0.status == statusFilter }
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            ForEach(filteredTasks) { task in
                TaskCardView(
                    task: Binding(
                        get: { task },
                        set: { updatedTask in
                            if let index = allTasks.firstIndex(where: { $0.id == task.id }) {
                                allTasks[index] = updatedTask
                            }
                        }
                    ),
                    allTasks: $allTasks,
                    onDelete: { task in
                        onDelete(task)
                    },
                    onEdit: { task in
                        onEdit(task)
                    },
                    viewModel: viewModel
                )
            }
        }
    }
}

#Preview {
    TaskColumnView(
        title: "To Do",
        tasks: .constant([]),
        statusFilter: "todo",
        allTasks: .constant([]),
        viewModel: BoardViewModel(),
        onEdit: { _ in },
        onDelete: { _ in }
    )
}
