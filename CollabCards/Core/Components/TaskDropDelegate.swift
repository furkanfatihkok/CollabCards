//
//  TaskDropDelegate.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct TaskDropDelegate: DropDelegate {
    let card: Card
    @Binding var allTasks: [Card]
    @ObservedObject var viewModel: CardViewModel
    let boardID: String

    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [UTType.text]).first else { return false }

        item.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (data, error) in
            guard let data = data as? Data, let id = String(data: data, encoding: .utf8) else { return }

            DispatchQueue.main.async {
                if let draggedTask = allTasks.first(where: { $0.id == id }) {
                    if let index = allTasks.firstIndex(where: { $0.id == draggedTask.id }) {
                        allTasks[index].status = card.status
                        viewModel.moveTask(draggedTask, toStatus: card.status, in: boardID)
                    }
                }
            }
        }
        return true
    }
}
