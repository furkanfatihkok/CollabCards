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
        newBoard.participants = [deviceID]
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
    
    func addBoardToCurrentDevice(boardID: UUID, completion: @escaping (Board?) -> Void) {
        guard let deviceID = UserDefaults.standard.string(forKey: "deviceID") else {
            Crashlytics.log("Failed to add board to current device: deviceID not found")
            completion(nil)
            return
        }
        
        let docRef = db.collection("boards").document(boardID.uuidString)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    var board = try document.data(as: Board.self)
                    if board.participants == nil {
                        board.participants = []
                    }
                    board.participants.append(deviceID)
                    self.updateBoard(board) { updatedBoard in
                        completion(updatedBoard)
                    }
                } catch {
                    Crashlytics.log("Error decoding board document: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                Crashlytics.log("Board not found for ID: \(boardID.uuidString)")
                completion(nil)
            }
        }
    }
    
    private func updateBoard(_ board: Board, completion: @escaping (Board?) -> Void) {
        do {
            let _ = try db.collection("boards").document(board.id.uuidString).setData(from: board) { error in
                if let error = error {
                    Crashlytics.log("Error updating board: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    Crashlytics.log("Board updated successfully with ID: \(board.id)")
                    completion(board)
                }
            }
        } catch {
            Crashlytics.log("Error updating board document: \(error.localizedDescription)")
            completion(nil)
        }
    }
}
