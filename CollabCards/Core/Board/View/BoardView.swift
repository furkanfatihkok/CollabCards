//
//  BoardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import FirebaseCrashlytics

struct BoardView: View {
    @Environment(\.presentationMode) var dismiss
    
    @StateObject var viewModel = BoardViewModel()
    
    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @State private var taskToEdit: Board? = nil
    @State private var isPaused = true
    
    var ideateDuration: Int
    var discussDuration: Int
    
    @State private var timerValue: TimeInterval
    
    init(ideateDuration: Int, discussDuration: Int) {
        self.ideateDuration = ideateDuration
        self.discussDuration = discussDuration
        _timerValue = State(initialValue: TimeInterval(ideateDuration * 60))
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
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
                ScrollView(.vertical) {
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
                                    Crashlytics.log("Editing task with id: \(String(describing: task.id))")
                                },
                                onDelete: { task in
                                    viewModel.deleteTask(task)
                                    Crashlytics.log("Deleted task with id: \(String(describing: task.id))")
                                }
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
                                    Crashlytics.log("Editing task with id: \(String(describing: task.id))")
                                },
                                onDelete: { task in
                                    viewModel.deleteTask(task)
                                    Crashlytics.log("Deleted task with id: \(String(describing: task.id))")
                                }
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
                                    Crashlytics.log("Editing task with id: \(String(describing: task.id))")
                                },
                                onDelete: { task in
                                    viewModel.deleteTask(task)
                                    Crashlytics.log("Deleted task with id: \(String(describing: task.id))")
                                }
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
            
            .navigationTitle("Task Board")
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
                                Crashlytics.log("Task edited with id: \(String(describing: task.id))")
                            }
                        ), viewModel: viewModel,
                        onSave: { updatedTask in
                            viewModel.editTask(updatedTask)
                            Crashlytics.log("Task saved with id: \(String(describing: updatedTask.id))")
                        }
                    )
                }
            }
        }
        .onAppear {
            viewModel.fetchTasks()
            Crashlytics.log("BoardView appeared.")
            Crashlytics.setCustomValue(ideateDuration, forkey: "ideateDuration")
            Crashlytics.setCustomValue(discussDuration, forkey: "discussDuration")
        }
    }
    
    func timerString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    BoardView(ideateDuration: 15, discussDuration: 20)
}
