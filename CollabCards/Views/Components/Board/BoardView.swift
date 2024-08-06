//
//  BoardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCrashlytics

struct BoardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = CardViewModel()
    @StateObject var boardViewModel = BoardViewModel()
    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @State private var isPaused = true
    @State private var isLoading = true
    @State private var taskToEdit: Card? = nil
    @State private var board: Board?
    @State private var timerValue: Int = 15 * 60
    var boardID: UUID
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if let board = board {
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                            Crashlytics.log("Back button pressed, dismissing BoardView.")
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(board.name)
                                .foregroundColor(.white)
                                .font(.headline)
                            Text("Furkan Kök's workspace")
                                .foregroundColor(.white)
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Text(timerString(from: TimeInterval(timerValue)))
                                .foregroundColor(.white)
                                .onReceive(timer) { _ in
                                    if !isPaused {
                                        if timerValue > 0 {
                                            timerValue -= 1
                                            boardViewModel.updateTimerInFirestore(boardID: boardID, timerValue: timerValue)
                                            viewModel.fetchTasks(for: boardID.uuidString) // Timer çalışırken de görevleri yeniden yükleyin
                                        } else {
                                            Crashlytics.log("Timer reached zero.")
                                            dismiss()
                                        }
                                    }
                                }
                            Button(action: {
                                isPaused.toggle()
                                boardViewModel.updateTimerStatusInFirestore(boardID: boardID, isPaused: isPaused)
                                Crashlytics.log(isPaused ? "Timer paused." : "Timer resumed.")
                            }) {
                                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                    .foregroundColor(.white)
                            }

                            Button(action: {
                                timerValue = board.timerValue ?? 15 * 60
                                isPaused = true
                                boardViewModel.updateTimerStatusInFirestore(boardID: boardID, isPaused: isPaused)
                                Crashlytics.log("Timer reset to initial duration.")
                            }) {
                                Image(systemName: "stop.fill")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        VStack {
                            Text("Went Well")
                                .font(.title2)
                                .bold()
                                .padding(.bottom, 8)
                            ScrollView(.vertical, showsIndicators: false) {
                                TaskColumnView(
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
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8)

                        VStack {
                            Text("To Improve")
                                .font(.title2)
                                .bold()
                                .padding(.bottom, 8)
                            ScrollView(.vertical, showsIndicators: false) {
                                TaskColumnView(
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
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8)

                        VStack {
                            Text("Action Items")
                                .font(.title2)
                                .bold()
                                .padding(.bottom, 8)
                            ScrollView(.vertical, showsIndicators: false) {
                                TaskColumnView(
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
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                    }
                    .padding(.horizontal)
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddSheet) {
            AddCardView(viewModel: viewModel, boardID: boardID.uuidString)
        }
        .sheet(isPresented: $showEditSheet) {
            if let task = taskToEdit {
                EditCardView(
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
                    status: .constant(task.status)
                )
            }
        }
        .onAppear {
            viewModel.fetchTasks(for: boardID.uuidString)
            Crashlytics.log("BoardView appeared for board ID: \(boardID.uuidString)")
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }

    private func loadBoard() {
        boardViewModel.fetchBoardWithRealtimeUpdates(boardID: boardID) { fetchedBoard in
            if let fetchedBoard = fetchedBoard {
                self.board = fetchedBoard
                if let timerValue = self.board?.timerValue {
                    self.timerValue = timerValue
                }
                if let isPaused = self.board?.isPaused {
                    self.isPaused = isPaused
                }
                Crashlytics.log("Board loaded with ID: \(self.board?.id.uuidString ?? "")")
            } else {
                Crashlytics.log("Failed to load board with ID: \(self.board?.id.uuidString ?? "")")
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