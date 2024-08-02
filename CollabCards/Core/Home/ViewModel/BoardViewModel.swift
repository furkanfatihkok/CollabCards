//  BoardViewModel.swift
//  CollabCards
//
//  Created by FFK on 2.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCrashlytics

class BoardViewModel: ObservableObject {
    @Published var boards = [Board]()
    private var db = Firestore.firestore()
    
    func fetchBoards() {
        guard let deviceID = UserDefaults.standard.string(forKey: "deviceID") else {
            Crashlytics.log("Failed to fetch boards: deviceID not found")
            return
        }
        db.collection("boards").whereField("participants", arrayContains: deviceID).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Crashlytics.log("Error fetching boards: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                Crashlytics.log("No documents found for boards")
                return
            }
            
            self.boards = documents.compactMap { queryDocumentSnapshot in
                do {
                    let board = try queryDocumentSnapshot.data(as: Board.self)
                    Crashlytics.log("Board fetched with ID: \(board.id)")
                    return board
                } catch {
                    Crashlytics.log("Error decoding document into Board: \(error.localizedDescription). Document data: \(queryDocumentSnapshot.data())")
                    return nil
                }
            }
        }
    }
    
    func addBoard(_ board: Board) {
        guard let deviceID = UserDefaults.standard.string(forKey: "deviceID") else {
            Crashlytics.log("Failed to add board: deviceID not found")
            return
        }
        var newBoard = board
        newBoard.deviceID = deviceID
        do {
            let _ = try db.collection("boards").document(board.id.uuidString).setData(from: newBoard) { error in
                if let error = error {
                    Crashlytics.log("Error adding board: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Board added successfully with ID: \(newBoard.id)")
                }
            }
        } catch {
            Crashlytics.log("Error creating board document: \(error.localizedDescription)")
        }
    }
    
    func deleteBoard(_ board: Board) {
        db.collection("boards").document(board.id.uuidString).delete { error in
            if let error = error {
                Crashlytics.log("Error deleting board with ID: \(board.id). Error: \(error.localizedDescription)")
            } else {
                Crashlytics.log("Board deleted successfully with ID: \(board.id)")
            }
        }
    }
}
