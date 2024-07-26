//
//  BoardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI


//TODO: EDİT VE DELETE UI DEĞİŞTİR
//TODO: BOŞ KARTA DA MOVE FONKSŞYINU SAĞLA.
//TODO: BOARD UI DEĞİŞTİR.

struct BoardView: View {
    @Environment(\.presentationMode) var dismiss

    @StateObject var viewModel = BoardViewModel()

    @State private var showAddSheet = false
    @State private var showEditSheet: Bool = false
    @State private var taskToEdit: Board? = nil
    @State private var timerValue: TimeInterval = 1 * 60 + 0
    @State private var isPaused = true

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Timer and Step Section
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
                                }
                            }
                        }
                    Button(action: {
                        isPaused.toggle()
                    }) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    }
                    Button(action: {
                        // Add action for stop/reset
                    }) {
                        Image(systemName: "stop.fill")
                    }
                    Button(action: {
                        // Add action for next step
                    }) {
                        Text("NEXT")
                    }
                }
                .padding()

                GeometryReader { geometry in
                    ScrollView(.horizontal) {
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
                                },
                                onDelete: { task in
                                    viewModel.deleteTask(task)
                                }
                            )
                            .frame(width: geometry.size.width * 0.75, height: 500)
                            
                            TaskColumnView(
                                title: "In Progress",
                                tasks: $viewModel.tasks,
                                statusFilter: "progress",
                                allTasks: $viewModel.tasks,
                                viewModel: viewModel,
                                onEdit: { task in
                                    taskToEdit = task
                                    showEditSheet = true
                                },
                                onDelete: { task in
                                    viewModel.deleteTask(task)
                                }
                            )
                            .frame(width: geometry.size.width * 0.75, height: 500)
                            
                            TaskColumnView(
                                title: "Done",
                                tasks: $viewModel.tasks,
                                statusFilter: "done",
                                allTasks: $viewModel.tasks,
                                viewModel: viewModel,
                                onEdit: { task in
                                    taskToEdit = task
                                    showEditSheet = true
                                },
                                onDelete: { task in
                                    viewModel.deleteTask(task)
                                }
                            )
                            .frame(width: geometry.size.width * 0.75, height: 500)
                        }
                        .padding(.horizontal)
                    }
                }

                Button(action: {
                    showAddSheet.toggle()
                }) {
                    Text("Add Card")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                .navigationTitle("Task Board")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.dismiss.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                        })
                    }
                }
                .sheet(isPresented: $showAddSheet) {
                    AddTaskView(viewModel: viewModel)
                }
                .sheet(isPresented: $showEditSheet) {
                    if let task = taskToEdit {
                        EditTaskView(
                            task: Binding(
                                get: { task },
                                set: { updatedTask in
                                    if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                        viewModel.tasks[index] = updatedTask
                                        viewModel.editTask(updatedTask)
                                    }
                                    taskToEdit = nil
                                    showEditSheet = false
                                }
                            ), viewModel: viewModel,
                            onSave: { updatedTask in
                                viewModel.editTask(updatedTask)
                            }
                        )
                    }
                }
            }
            .onAppear {
                viewModel.fetchTasks()
            }
        }
    }

    func timerString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    BoardView()
}
