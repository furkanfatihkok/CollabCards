//  CardViewModel.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCrashlytics

class CardViewModel: ObservableObject {
    @Published var tasks = [Card]()
    private var db = Firestore.firestore()
    
    func fetchTasks(for boardID: String) {
        db.collection("boards").document(boardID).collection("tasks").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Crashlytics.log("Error fetching tasks: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                Crashlytics.log("No documents found for tasks")
                return
            }
            
            self.tasks = documents.compactMap { queryDocumentSnapshot in
                do {
                    let task = try queryDocumentSnapshot.data(as: Card.self)
                    Crashlytics.log("Task fetched with ID: \(task.id ?? "")")
                    return task
                } catch {
                    Crashlytics.log("Error decoding document into Task: \(error.localizedDescription). Document data: \(queryDocumentSnapshot.data())")
                    return nil
                }
            }
        }
    }
    
    func addTask(_ task: Card, to boardID: String, completion: @escaping () -> Void) {
        do {
            let _ = try db.collection("boards").document(boardID).collection("tasks").document(task.id ?? "").setData(from: task) { error in
                if let error = error {
                    Crashlytics.log("Error adding task: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Task added successfully with ID: \(task.id ?? "")")
                    completion()
                }
            }
        } catch {
            Crashlytics.log("Error creating task document: \(error.localizedDescription)")
        }
    }
    
    func deleteTask(_ task: Card, from boardID: String) {
        guard let taskId = task.id else {
            Crashlytics.log("Failed to delete task: task ID is nil")
            return
        }
        
        db.collection("boards").document(boardID).collection("tasks").document(taskId).delete { error in
            if let error = error {
                Crashlytics.log("Error deleting task with ID: \(taskId). Error: \(error.localizedDescription)")
            } else {
                Crashlytics.log("Task deleted successfully with ID: \(taskId)")
            }
        }
    }
    
    func moveTask(_ task: Card, toStatus newStatus: String, in boardID: String) {
        guard let taskId = task.id else {
            Crashlytics.log("Failed to move task: task ID is nil")
            return
        }
        
        db.collection("boards").document(boardID).collection("tasks").document(taskId).updateData(["status": newStatus]) { error in
            if let error = error {
                Crashlytics.log("Error updating task status with ID: \(taskId). Error: \(error.localizedDescription)")
            } else {
                Crashlytics.log("Task status updated successfully with ID: \(taskId) to status: \(newStatus)")
            }
        }
    }
    
    func editTask(_ task: Card, in boardID: String) {
        guard let taskId = task.id else {
            Crashlytics.log("Failed to edit task: task ID is nil")
            return
        }
        
        do {
            let _ = try db.collection("boards").document(boardID).collection("tasks").document(taskId).setData(from: task) { error in
                if let error = error {
                    Crashlytics.log("Error updating task document with ID: \(taskId). Error: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Task document updated successfully with ID: \(taskId)")
                }
            }
        } catch {
            Crashlytics.log("Error creating task document: \(error.localizedDescription)")
        }
    }
}
