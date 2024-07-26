//
//  BoardViewModel.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import Foundation
import FirebaseFirestore

class BoardViewModel: ObservableObject {
    @Published var tasks = [Task]()
    private var db = Firestore.firestore()
    
    func fetchTasks() {
        db.collection("tasks").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.tasks = documents.compactMap { queryDocumentSnapshot in
                do {
                    let task = try queryDocumentSnapshot.data(as: Task.self)
                    return task
                } catch {
                    print("Error decoding document into Task: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    func addTask(_ task: Task) {
        do {
            let _ = try db.collection("tasks").addDocument(from: task) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document added successfully")
                }
            }
        } catch {
            print("Error creating document: \(error.localizedDescription)")
        }
    }
    
}
