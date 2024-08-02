//
//  BoardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import FirebaseFirestore

struct BoardView: View {
    @Environment(\.presentationMode) var dismiss
    @ObservedObject var viewModel = CardViewModel()
    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @State private var taskToEdit: Card? = nil
    @State private var isPaused = true
    @State private var board: Board?
    @State private var timerValue: TimeInterval
    
    var ideateDuration: Int
    var discussDuration: Int
    var boardID: UUID
    
    init(ideateDuration: Int = 15, discussDuration: Int = 20, boardID: UUID) {
        self.ideateDuration = ideateDuration
        self.discussDuration = discussDuration
        self.boardID = boardID
        _timerValue = State(initialValue: TimeInterval(ideateDuration * 60))
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if let board = board {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("Step 2/6 :")
                        Text("Ideate")
                    }
                    
                    Spacer()
                    
                    Text(timerString(from: timerValue))
                        .onReceive(timer) { _ in
                            if !isPaused {
                                if timerValue > 0 {
                                    timerValue -= 1
                                } else {
                                    // Log when the timer reaches zero
                                    print("Timer reached zero.")
                                }
                            }
                        }
                    
                    Button(action: {
                        isPaused.toggle()
                        print(isPaused ? "Timer paused." : "Timer resumed.")
                    }) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    }
                    
                    Button(action: {
                        timerValue = TimeInterval(ideateDuration * 60)
                        print("Timer reset to initial duration.")
                    }) {
                        Image(systemName: "stop.fill")
                    }
                    
                    Button(action: {
                        // Add action for next step
                        print("Next step button pressed.")
                    }) {
                        Text("NEXT")
                    }
                }
                .padding()
                
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                TaskColumnView(
                                    title: "To Do",
                                    tasks: $viewModel.tasks,
                                    statusFilter: "todo",
                                    allTasks: $viewModel.tasks,
                                    viewModel: viewModel,
                                    onEdit: { task in
                                        taskToEdit = task
                                        showEditSheet = true
                                        print("Editing task with id: \(String(describing: task.id))")
                                    },
                                    onDelete: { task in
                                        viewModel.deleteTask(task, from: boardID.uuidString)
                                        print("Deleted task with id: \(String(describing: task.id))")
                                    },
                                    boardID: boardID.uuidString
                                )
                                .frame(width: geometry.size.width * 0.75)
                                
                                TaskColumnView(
                                    title: "In Progress",
                                    tasks: $viewModel.tasks,
                                    statusFilter: "progress",
                                    allTasks: $viewModel.tasks,
                                    viewModel: viewModel,
                                    onEdit: { task in
                                        taskToEdit = task
                                        showEditSheet = true
                                        print("Editing task with id: \(String(describing: task.id))")
                                    },
                                    onDelete: { task in
                                        viewModel.deleteTask(task, from: boardID.uuidString)
                                        print("Deleted task with id: \(String(describing: task.id))")
                                    },
                                    boardID: boardID.uuidString
                                )
                                .frame(width: geometry.size.width * 0.75)
                                
                                TaskColumnView(
                                    title: "Done",
                                    tasks: $viewModel.tasks,
                                    statusFilter: "done",
                                    allTasks: $viewModel.tasks,
                                    viewModel: viewModel,
                                    onEdit: { task in
                                        taskToEdit = task
                                        showEditSheet = true
                                        print("Editing task with id: \(String(describing: task.id))")
                                    },
                                    onDelete: { task in
                                        viewModel.deleteTask(task, from: boardID.uuidString)
                                        print("Deleted task with id: \(String(describing: task.id))")
                                    },
                                    boardID: boardID.uuidString
                                )
                                .frame(width: geometry.size.width * 0.75)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            } else {
                Text("Loading...")
                    .onAppear {
                        loadBoard()
                    }
            }
        }
        
        Button(action: {
            showAddSheet.toggle()
            print("Add card button pressed.")
        }) {
            Text("Add Card")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        
        .navigationTitle(board?.name ?? "Board")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.dismiss.wrappedValue.dismiss()
                    print("Back button pressed, dismissing BoardView.")
                }, label: {
                    Image(systemName: "arrow.left")
                })
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddTaskView(viewModel: viewModel, boardID: boardID.uuidString)
        }
        .sheet(isPresented: $showEditSheet) {
            if let task = taskToEdit {
                EditTaskView(
                    task: Binding(
                        get: { task },
                        set: { updatedTask in
                            if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                viewModel.tasks[index] = updatedTask
                                viewModel.editTask(updatedTask, in: boardID.uuidString)
                            }
                            taskToEdit = nil
                            showEditSheet = false
                            print("Task edited with id: \(String(describing: task.id))")
                        }
                    ),
                    viewModel: viewModel,
                    boardID: boardID.uuidString
                ) { updatedTask in
                    viewModel.editTask(updatedTask, in: boardID.uuidString)
                    print("Task saved with id: \(String(describing: updatedTask.id))")
                }
            }
        }
        .onAppear {
            viewModel.fetchTasks(for: boardID.uuidString)
            print("BoardView appeared.")
        }
    }
    
    private func loadBoard() {
        // Firestore'dan board'u yükleyin
        let docRef = Firestore.firestore().collection("boards").document(boardID.uuidString)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    self.board = try document.data(as: Board.self)
                } catch {
                    print("Error decoding board: \(error.localizedDescription)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

func timerString(from timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%02d:%02d", minutes, seconds)
}

#Preview {
    BoardView(ideateDuration: 15, discussDuration: 20, boardID: UUID())
}
