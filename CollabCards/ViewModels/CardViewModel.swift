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
    private var listener: ListenerRegistration?

    func fetchTasks(for boardID: String) {
        listener?.remove()
        listener = db.collection("boards").document(boardID).collection("tasks").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    Crashlytics.log("Error fetching tasks: \(error.localizedDescription)")
                }
                return
            }

            guard let documents = querySnapshot?.documents else {
                DispatchQueue.main.async {
                    Crashlytics.log("No documents found for tasks")
                }
                return
            }

            DispatchQueue.main.async {
                self.tasks = documents.compactMap { queryDocumentSnapshot in
                    do {
                        let task = try queryDocumentSnapshot.data(as: Card.self)
                        Crashlytics.log("Task fetched with ID: \(task.id)")
                        return task
                    } catch {
                        Crashlytics.log("Error decoding document into Task: \(error.localizedDescription). Document data: \(queryDocumentSnapshot.data())")
                        return nil
                    }
                }
            }
        }
    }

    func addTask(_ task: Card, to boardID: String, completion: @escaping () -> Void) {
        do {
            let _ = try db.collection("boards").document(boardID).collection("tasks").document(task.id).setData(from: task) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        Crashlytics.log("Error adding task: \(error.localizedDescription)")
                    } else {
                        Crashlytics.log("Task added successfully with ID: \(task.id)")
                        completion()
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                Crashlytics.log("Error creating task document: \(error.localizedDescription)")
            }
        }
    }

    func deleteTask(_ task: Card, from boardID: String) {
        db.collection("boards").document(boardID).collection("tasks").document(task.id).delete { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error deleting task with ID: \(task.id). Error: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Task deleted successfully with ID: \(task.id)")
                }
            }
        }
    }

    func moveTask(_ task: Card, toStatus newStatus: String, in boardID: String) {
        db.collection("boards").document(boardID).collection("tasks").document(task.id).updateData(["status": newStatus]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error updating task status with ID: \(task.id). Error: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Task status updated successfully with ID: \(task.id) to status: \(newStatus)")
                }
            }
        }
    }

    func editTask(_ task: Card, in boardID: String) {
        do {
            let _ = try db.collection("boards").document(boardID).collection("tasks").document(task.id).setData(from: task) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        Crashlytics.log("Error updating task document with ID: \(task.id). Error: \(error.localizedDescription)")
                    } else {
                        Crashlytics.log("Task document updated successfully with ID: \(task.id)")
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                Crashlytics.log("Error creating task document: \(error.localizedDescription)")
            }
        }
    }
}

