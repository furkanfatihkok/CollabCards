//  CardViewModel.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCrashlytics

class CardViewModel: ObservableObject {
    @Published var cards = [Card]()
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchTasks(for boardID: String) {
        listener?.remove()
        listener = db.collection("boards").document(boardID).collection("cards").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    Crashlytics.log("Error fetching cards: \(error.localizedDescription)")
                }
                return
            }

            guard let documents = querySnapshot?.documents else {
                DispatchQueue.main.async {
                    Crashlytics.log("No documents found for cards")
                }
                return
            }

            DispatchQueue.main.async {
                self.cards = documents.compactMap { queryDocumentSnapshot in
                    do {
                        let card = try queryDocumentSnapshot.data(as: Card.self)
                        Crashlytics.log("Task fetched with ID: \(card.id)")
                        return card
                    } catch {
                        Crashlytics.log("Error decoding document into Task: \(error.localizedDescription). Document data: \(queryDocumentSnapshot.data())")
                        return nil
                    }
                }
            }
        }
    }

    func addTask(_ card: Card, to boardID: String, completion: @escaping () -> Void) {
        do {
            let _ = try db.collection("boards").document(boardID).collection("cards").document(card.id).setData(from: card) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        Crashlytics.log("Error adding card: \(error.localizedDescription)")
                    } else {
                        Crashlytics.log("Task added successfully with ID: \(card.id)")
                        completion()
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                Crashlytics.log("Error creating card document: \(error.localizedDescription)")
            }
        }
    }

    func deleteTask(_ card: Card, from boardID: String) {
        db.collection("boards").document(boardID).collection("cards").document(card.id).delete { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error deleting card with ID: \(card.id). Error: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Task deleted successfully with ID: \(card.id)")
                }
            }
        }
    }

    func moveTask(_ card: Card, toStatus newStatus: String, in boardID: String) {
        db.collection("boards").document(boardID).collection("cards").document(card.id).updateData(["status": newStatus]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error updating card status with ID: \(card.id). Error: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Task status updated successfully with ID: \(card.id) to status: \(newStatus)")
                }
            }
        }
    }

    func editTask(_ card: Card, in boardID: String) {
        do {
            let _ = try db.collection("boards").document(boardID).collection("cards").document(card.id).setData(from: card) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        Crashlytics.log("Error updating card document with ID: \(card.id). Error: \(error.localizedDescription)")
                    } else {
                        Crashlytics.log("Task document updated successfully with ID: \(card.id)")
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                Crashlytics.log("Error creating card document: \(error.localizedDescription)")
            }
        }
    }
}

