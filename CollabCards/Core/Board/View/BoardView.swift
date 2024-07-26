//
//  BoardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI

struct BoardView: View {
    
    @Environment(\.presentationMode) var dismiss
    @StateObject var viewModel = BoardViewModel()
    @State private var showAddSheet = false
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
                
                HStack {
                    TaskColumnView(title: "To Do", tasks: viewModel.tasks.filter { $0.status == "todo" })
                    TaskColumnView(title: "In Progress", tasks: viewModel.tasks.filter { $0.status == "progress" })
                    TaskColumnView(title: "Done", tasks: viewModel.tasks.filter { $0.status == "done" })
                }
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddSheet.toggle()
                        }) {
                            Text("Add Card")
                        }
                        
                    }
                }
                .sheet(isPresented: $showAddSheet) {
                    AddTaskView(viewModel: viewModel)
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
