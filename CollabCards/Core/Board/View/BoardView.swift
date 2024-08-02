//  BoardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCrashlytics

struct BoardView: View {
    @Environment(\.presentationMode) var dismiss
    @ObservedObject var viewModel = CardViewModel()
    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @State private var isPaused = true
    @State private var isLoading = true
    @State private var taskToEdit: Card? = nil
    @State private var board: Board?
    @State private var timerValue: TimeInterval = 15 * 60
    
    var ideateDuration: Int = 15
    var discussDuration: Int = 20
    var boardID: UUID
    
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
                                    Crashlytics.log("Timer reached zero.")
                                }
                            }
                        }
                    
                    Button(action: {
                        isPaused.toggle()
                        Crashlytics.log(isPaused ? "Timer paused." : "Timer resumed.")
                    }) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    }
                    
                    Button(action: {
                        timerValue = TimeInterval(ideateDuration * 60)
                        Crashlytics.log("Timer reset to initial duration.")
                    }) {
                        Image(systemName: "stop.fill")
                    }
                    
                    Button(action: {
                        // Add action for next step
                        Crashlytics.log("Next step button pressed.")
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
                                    title: "Went Well",
                                    tasks: $viewModel.tasks,
                                    statusFilter: "went well",
                                    allTasks: $viewModel.tasks,
                                    viewModel: viewModel,
                                    onEdit: { task in
                                        taskToEdit = task
                                        showEditSheet = true
                                        Crashlytics.log("Editing task with id: \(String(describing: task.id))")
                                    },
                                    onDelete: { task in
                                        viewModel.deleteTask(task, from: boardID.uuidString)
                                        Crashlytics.log("Deleted task with id: \(String(describing: task.id))")
                                    },
                                    boardID: boardID.uuidString
                                )
                                .frame(width: geometry.size.width * 0.75)
                                
                                TaskColumnView(
                                    title: "To Improve",
                                    tasks: $viewModel.tasks,
                                    statusFilter: "to improve",
                                    allTasks: $viewModel.tasks,
                                    viewModel: viewModel,
                                    onEdit: { task in
                                        taskToEdit = task
                                        showEditSheet = true
                                        Crashlytics.log("Editing task with id: \(String(describing: task.id))")
                                    },
                                    onDelete: { task in
                                        viewModel.deleteTask(task, from: boardID.uuidString)
                                        Crashlytics.log("Deleted task with id: \(String(describing: task.id))")
                                    },
                                    boardID: boardID.uuidString
                                )
                                .frame(width: geometry.size.width * 0.75)
                                
                                TaskColumnView(
                                    title: "Action Items",
                                    tasks: $viewModel.tasks,
                                    statusFilter: "action items",
                                    allTasks: $viewModel.tasks,
                                    viewModel: viewModel,
                                    onEdit: { task in
                                        taskToEdit = task
                                        showEditSheet = true
                                        Crashlytics.log("Editing task with id: \(String(describing: task.id))")
                                    },
                                    onDelete: { task in
                                        viewModel.deleteTask(task, from: boardID.uuidString)
                                        Crashlytics.log("Deleted task with id: \(String(describing: task.id))")
                                    },
                                    boardID: boardID.uuidString
                                )
                                .frame(width: geometry.size.width * 0.75)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Button(action: {
                    showAddSheet.toggle()
                    Crashlytics.log("Add card button pressed.")
                }) {
                    Text("Add Card")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            } else if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                .onAppear {
                    loadBoard()
                    Crashlytics.log("BoardView loading board with ID: \(boardID.uuidString)")
                }
            } else {
                Text("Failed to load board.")
            }
        }
        
        .navigationTitle(board?.name ?? "Board")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.dismiss.wrappedValue.dismiss()
                    Crashlytics.log("Back button pressed, dismissing BoardView.")
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
                    task: .constant(task),
                    viewModel: viewModel,
                    onSave: { updatedTask in
                        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                            viewModel.tasks[index] = updatedTask
                            viewModel.editTask(updatedTask, in: boardID.uuidString)
                            Crashlytics.log("Task edited with id: \(String(describing: task.id))")
                        }
                        taskToEdit = nil
                        showEditSheet = false
                    }, boardID: boardID.uuidString,
                    title: .constant(task.title),
                    description: .constant(task.description),
                    status: .constant(task.status)
                )
            }
        }
        .onAppear {
            viewModel.fetchTasks(for: boardID.uuidString)
            Crashlytics.log("BoardView appeared for board ID: \(boardID.uuidString)")
        }
    }
    
    private func loadBoard() {
        let docRef = Firestore.firestore().collection("boards").document(boardID.uuidString)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    self.board = try document.data(as: Board.self)
                    Crashlytics.log("Board loaded with ID: \(boardID.uuidString)")
                } catch {
                    Crashlytics.log("Error decoding board: \(error.localizedDescription)")
                }
            } else {
                Crashlytics.log("Document does not exist for board ID: \(boardID.uuidString)")
            }
            self.isLoading = false
        }
    }
}

func timerString(from timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%02d:%02d", minutes, seconds)
}

#Preview {
    BoardView(boardID: UUID())
}
