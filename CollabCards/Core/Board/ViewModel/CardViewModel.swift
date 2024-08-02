//
//  CardViewModel.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import Foundation
import FirebaseFirestore

class CardViewModel: ObservableObject {
    @Published var tasks = [Card]()
    private var db = Firestore.firestore()
    
    func fetchTasks(for boardID: String) {
        db.collection("boards").document(boardID).collection("tasks").addSnapshotListener { (querySnapshot, error) in
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
                    let task = try queryDocumentSnapshot.data(as: Card.self)
                    return task
                } catch {
                    print("Error decoding document into Task: \(error.localizedDescription)")
                    print("Document data: \(queryDocumentSnapshot.data())")
                    return nil
                }
            }
        }
    }
    
    func addTask(_ task: Card, to boardID: String) {
        do {
            let _ = try db.collection("boards").document(boardID).collection("tasks").document(task.id ?? "").setData(from: task) { error in
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
    
    func deleteTask(_ task: Card, from boardID: String) {
        guard let taskId = task.id else { return }
        
        db.collection("boards").document(boardID).collection("tasks").document(taskId).delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document deleted successfully")
            }
        }
    }
    
    func moveTask(_ task: Card, toStatus newStatus: String, in boardID: String) {
        guard let taskId = task.id else { return }
        
        db.collection("boards").document(boardID).collection("tasks").document(taskId).updateData(["status": newStatus]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document updated successfully")
            }
        }
    }
    
    func editTask(_ task: Card, in boardID: String) {
        guard let taskId = task.id else { return }
        
        do {
            let _ = try db.collection("boards").document(boardID).collection("tasks").document(taskId).setData(from: task) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document updated successfully")
                }
            }
        } catch {
            print("Error creating document: \(error.localizedDescription)")
        }
    }
}
