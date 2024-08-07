//
//  TaskCardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct TaskCardView: View {
    @Binding var task: Card
    @Binding var allTasks: [Card]
    
    var onDelete: (Card) -> Void
    var onEdit: (Card) -> Void
    var viewModel: CardViewModel
    var boardID: String
    var isAnonymous: Bool
    var boardUsername: String 
    
    @State private var showEditSheet = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .foregroundStyle(.white)
                    .padding(.bottom, 2)
                
                if !isAnonymous {
                    Text(boardUsername)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor(for: task.status))
            .cornerRadius(8)
            .shadow(radius: 3)
            .onDrag {
                let data = task.id?.data(using: .utf8) ?? Data()
                let provider = NSItemProvider(item: data as NSSecureCoding, typeIdentifier: UTType.text.identifier)
                return provider
            }
            .onDrop(of: [UTType.text], delegate: CardDropDelegate(card: task, allTasks: $allTasks, viewModel: viewModel, boardID: boardID))
            
            HStack {
                Button(action: { showEditSheet.toggle() }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showEditSheet) {
                    EditCardView(
                        task: $task,
                        viewModel: viewModel,
                        onSave: { updatedTask in
                            viewModel.editTask(updatedTask, in: boardID)
                            showEditSheet = false
                        }, boardID: boardID,
                        boardUsername: boardUsername,
                        title: $task.title,
                        status: $task.status
                    )
                }
                
                Button(action: { onDelete(task) }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding(.trailing, 5)
        }
    }
    
    func backgroundColor(for status: String) -> Color {
        switch status {
        case "went well":
            return Color(red: 0.0, green: 100.0/255.0, blue: 0.0)
        case "to improve":
            return Color(red: 255.0/255.0, green: 69.0/255.0, blue: 0.0)
        case "action items":
            return Color.purple
        default:
            return Color.gray
        }
    }
}
