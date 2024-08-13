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
    
    func fetchCards(for boardID: String) {
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
                        Crashlytics.log("Card fetched with ID: \(card.id)")
                        return card
                    } catch {
                        Crashlytics.log("Error decoding document into Card: \(error.localizedDescription). Document data: \(queryDocumentSnapshot.data())")
                        return nil
                    }
                }
            }
        }
    }
    
    func addCard(_ card: Card, to boardID: String, completion: @escaping () -> Void) {
        var newCard = card
        newCard.author = UserDefaults.standard.string(forKey: "username")
        newCard.date = Date()
        
        do {
            let _ = try db.collection("boards").document(boardID).collection("cards").document(card.id.uuidString).setData(from: newCard) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        Crashlytics.log("Kart ekleme hatası: \(error.localizedDescription)")
                    } else {
                        Crashlytics.log("Kart başarıyla eklendi: ID: \(newCard.id)")
                        completion()
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                Crashlytics.log("Kart belgesi oluşturma hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteCard(_ card: Card, from boardID: String) {
        db.collection("boards").document(boardID).collection("cards").document(card.id.uuidString).delete { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error deleting card with ID: \(card.id). Error: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Card deleted successfully with ID: \(card.id)")
                }
            }
        }
    }
    
    func moveCard(_ card: Card, toStatus newStatus: String, in boardID: String) {
        db.collection("boards").document(boardID).collection("cards").document(card.id.uuidString).updateData(["status": newStatus]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error updating card status with ID: \(card.id). Error: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Card status updated successfully with ID: \(card.id) to status: \(newStatus)")
                }
            }
        }
    }
    
    func editCard(_ card: Card, in boardID: String) {
        do {
            let _ = try db.collection("boards").document(boardID).collection("cards").document(card.id.uuidString).setData(from: card) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        Crashlytics.log("Error updating card document with ID: \(card.id). Error: \(error.localizedDescription)")
                    } else {
                        Crashlytics.log("Card document updated successfully with ID: \(card.id)")
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
