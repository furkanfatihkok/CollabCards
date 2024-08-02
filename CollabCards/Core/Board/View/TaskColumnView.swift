//
//  TaskColumnView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct TaskColumnView: View {
    let title: String
    @Binding var tasks: [Card]
    let statusFilter: String
    @Binding var allTasks: [Card]
    var viewModel: CardViewModel
    var onEdit: (Card) -> Void
    var onDelete: (Card) -> Void
    var boardID: String
    
    var filteredTasks: [Card] {
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
                    viewModel: viewModel,
                    boardID: boardID
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
        viewModel: CardViewModel(),
        onEdit: { _ in },
        onDelete: { _ in },
        boardID: UUID().uuidString
    )
}
