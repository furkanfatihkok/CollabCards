//
//  deneme.swift
//  CollabCards
//
//  Created by FFK on 25.07.2024.
//


//TODO: UI DÜZELT
//TODO: DİNAMİKLEŞTİR(TİMER)
//TODO: DOSYA DÜZENİ OLUŞTUR
//TODO: DESCRİPTİON EKLE.
//TODO: ADDCARD BUTTONUNU CARD'IN ALTINA KOY.
//TODO:

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

//struct Task: Identifiable, Codable {
//    @DocumentID var id: String?
//    var title: String
//    var description: String
//    var status: String
//}

//class TaskViewModel: ObservableObject {
//    @Published var tasks = [Task]()
//    private var db = Firestore.firestore()
//    
//    func fetchTasks() {
//        db.collection("tasks").addSnapshotListener { (querySnapshot, error) in
//            if let error = error {
//                print("Error fetching documents: \(error.localizedDescription)")
//                return
//            }
//
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//            
//            self.tasks = documents.compactMap { queryDocumentSnapshot in
//                do {
//                    let task = try queryDocumentSnapshot.data(as: Task.self)
//                    return task
//                } catch {
//                    print("Error decoding document into Task: \(error.localizedDescription)")
//                    return nil
//                }
//            }
//        }
//    }
//
//    func addTask(_ task: Task) {
//        do {
//            let _ = try db.collection("tasks").addDocument(from: task) { error in
//                if let error = error {
//                    print("Error adding document: \(error.localizedDescription)")
//                } else {
//                    print("Document added successfully")
//                }
//            }
//        } catch {
//            print("Error creating document: \(error.localizedDescription)")
//        }
//    }
//
//}

//struct deneme: View {
//    
//    @Environment(\.presentationMode) var dismiss
//    @StateObject var viewModel = TaskViewModel()
//    @State private var showAddSheet = false
//    @State private var timerValue: TimeInterval = 1 * 60 + 0 
//    @State private var isPaused = true
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    // Timer and Step Section
//                    Image(systemName: "person.crop.circle")
//                        .resizable()
//                        .frame(width: 40, height: 40)
//                        .clipShape(Circle())
//                    VStack(alignment: .leading) {
//                        Text("Step 2/6 :")
//                        Text("Ideate")
//                    }
//                    Spacer()
//                    Text(timerString(from: timerValue))
//                        .onReceive(timer) { _ in
//                            if !isPaused {
//                                if timerValue > 0 {
//                                    timerValue -= 1
//                                }
//                            }
//                        }
//                    Button(action: {
//                        isPaused.toggle()
//                    }) {
//                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
//                    }
//                    Button(action: {
//                        // Add action for stop/reset
//                    }) {
//                        Image(systemName: "stop.fill")
//                    }
//                    Button(action: {
//                        // Add action for next step
//                    }) {
//                        Text("NEXT")
//                    }
//                }
//                .padding()
//                
//                HStack {
//                    TaskColumnView(title: "To Do", tasks: viewModel.tasks.filter { $0.status == "todo" })
//                    TaskColumnView(title: "In Progress", tasks: viewModel.tasks.filter { $0.status == "progress" })
//                    TaskColumnView(title: "Done", tasks: viewModel.tasks.filter { $0.status == "done" })
//                }
//                .navigationTitle("Task Board")
//                .navigationBarTitleDisplayMode(.inline)
//                .navigationBarBackButtonHidden(true)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//                            self.dismiss.wrappedValue.dismiss()
//                        }, label: {
//                            Image(systemName: "arrow.left")
//                        })
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            showAddSheet.toggle()
//                        }) {
//                            Text("Add Card")
//                        }
//                    
//                    }
//                }
//                .sheet(isPresented: $showAddSheet) {
//                    AddTaskView(viewModel: viewModel)
//                }
//            }
//            .onAppear {
//                viewModel.fetchTasks()
//            }
//        }
//    }
//    
//    func timerString(from timeInterval: TimeInterval) -> String {
//        let minutes = Int(timeInterval) / 60
//        let seconds = Int(timeInterval) % 60
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
//}

/*
struct TaskColumnView: View {
    var title: String
    var tasks: [Task]
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            List(tasks) { task in
                Text(task.title)
            }
        }
    }
}
*/

//struct AddTaskView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var viewModel: BoardViewModel
//    @State private var title = ""
//    @State private var description = ""
//    @State private var status = "todo"
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                TextField("Title", text: $title)
//                TextField("Description", text: $description)
//                Picker("Status", selection: $status) {
//                    Text("To Do").tag("todo")
//                    Text("In Progress").tag("progress")
//                    Text("Done").tag("done")
//                }
//            }
//            .navigationTitle("New Task")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Save") {
//                        guard !title.isEmpty, !description.isEmpty else {
//                            print("Title or Description is empty")
//                            return
//                        }
//                        let task = Task(title: title, description: description, status: status)
//                        viewModel.addTask(task)
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//        }
//    }
//}

//
//#Preview {
//    deneme()
//}
