//
//  BoardViewModel.swift
//  CollabCards
//
//  Created by FFK on 2.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCrashlytics

class BoardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var boards = [Board]()
    @Published var isDateVisible: Bool = false
    @Published var isMoveCardsDisabled: Bool = false
    @Published var isAddEditCardsDisabled: Bool = false
    @Published var hideCards: Bool = false
    
    // MARK: - Private Properties
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // MARK: - Fetch Methods
    func fetchBoards() {
        guard let deviceID = UserDefaults.standard.string(forKey: "deviceID") else {
            Crashlytics.log("Failed to fetch boards: deviceID not found")
            return
        }
        
        let deletedBoardIDs = UserDefaults.standard.array(forKey: "deletedBoardIDs") as? [String] ?? []
        
        listener?.remove()
        listener = db.collection("boards").whereField("participants", arrayContains: deviceID).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                Crashlytics.log("Error fetching boards: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                Crashlytics.log("No documents found for boards")
                return
            }
            
            DispatchQueue.main.async {
                self.boards = documents.compactMap { queryDocumentSnapshot in
                    do {
                        let board = try queryDocumentSnapshot.data(as: Board.self)
                        if deletedBoardIDs.contains(board.id.uuidString) {
                            return nil
                        }
                        Crashlytics.log("Board fetched with ID: \(board.id)")
                        return board
                    } catch {
                        Crashlytics.log("Error decoding document into Board: \(error.localizedDescription). Document data: \(queryDocumentSnapshot.data())")
                        return nil
                    }
                }
            }
        }
    }
    
    func fetchBoardSettings(boardID: UUID) {
        let docRef = db.collection("boards").document(boardID.uuidString)
        docRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                Crashlytics.log("Error fetching board settings: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot else {
                Crashlytics.log("No document found for board with ID: \(boardID.uuidString)")
                return
            }
            
            DispatchQueue.main.async {
                self.isDateVisible = document.get("isDateVisible") as? Bool ?? false
                self.isMoveCardsDisabled = document.get("isMoveCardsDisabled") as? Bool ?? false
                self.isAddEditCardsDisabled = document.get("isAddEditCardsDisabled") as? Bool ?? false
                self.hideCards = document.get("hideCards") as? Bool ?? false
            }
        }
    }
    
    func fetchBoardWithRealtimeUpdates(boardID: UUID, completion: @escaping (Board?) -> Void) {
        let docRef = db.collection("boards").document(boardID.uuidString)
        listener = docRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                Crashlytics.log("Error fetching board: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let document = documentSnapshot else {
                Crashlytics.log("No document found for board with ID: \(boardID.uuidString)")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let board = try document.data(as: Board.self)
                    self.isDateVisible = board.isDateVisible ?? false
                    self.isMoveCardsDisabled = board.isMoveCardsDisabled ?? false
                    self.isAddEditCardsDisabled = board.isAddEditCardsDisabled ?? false
                    Crashlytics.log("Board fetched with realtime updates for ID: \(boardID.uuidString)")
                    completion(board)
                } catch {
                    Crashlytics.log("Error decoding board: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - CRUD Methods
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
                DispatchQueue.main.async {
                    if let error = error {
                        Crashlytics.log("Error adding board: \(error.localizedDescription)")
                    } else {
                        Crashlytics.log("Board added successfully with ID: \(newBoard.id)")
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                Crashlytics.log("Error creating board document: \(error.localizedDescription)")
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
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    do {
                        var board = try document.data(as: Board.self)
                        if board.participants == nil {
                            board.participants = []
                        }
                        board.participants.append(deviceID)
                        if board.usernames == nil {
                            board.usernames = [:]
                        }
                        board.usernames?[deviceID] = self.usernameForDevice()
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
    }
    
    func deleteBoard(_ board: Board) {
        db.collection("boards").document(board.id.uuidString).delete { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error deleting board with ID: \(board.id). Error: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Board deleted successfully with ID: \(board.id)")
                }
            }
        }
    }
    
    func deleteAllCards(for boardID: UUID) {
        let cardsRef = db.collection("boards").document(boardID.uuidString).collection("cards")
        cardsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                Crashlytics.log("Error deleting all cards: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                Crashlytics.log("No cards found to delete.")
                return
            }
            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        Crashlytics.log("Error deleting card with ID \(document.documentID): \(error.localizedDescription)")
                    } else {
                        Crashlytics.log("Card deleted with ID \(document.documentID)")
                    }
                }
            }
        }
    }
    
    func deleteBoardLocally(_ board: Board) {
        if let index = boards.firstIndex(where: { $0.id == board.id }) {
            boards.remove(at: index)
            
            var deletedBoardIDs = UserDefaults.standard.array(forKey: "deletedBoardIDs") as? [String] ?? []
            deletedBoardIDs.append(board.id.uuidString)
            UserDefaults.standard.set(deletedBoardIDs, forKey: "deletedBoardIDs")
        }
    }
    
    // MARK: - Update Methods
    func updateBoardSettings(boardID: UUID, isDateVisible: Bool, isMoveCardsDisabled: Bool, isAddEditCardsDisabled: Bool, hideCards: Bool) {
        db.collection("boards").document(boardID.uuidString).updateData([
            "isDateVisible": isDateVisible,
            "isMoveCardsDisabled": isMoveCardsDisabled,
            "isAddEditCardsDisabled": isAddEditCardsDisabled,
            "hideCards": hideCards
        ]) { error in
            if let error = error {
                Crashlytics.log("Error updating board settings: \(error.localizedDescription)")
            } else {
                Crashlytics.log("Board settings updated successfully for ID: \(boardID.uuidString)")
            }
        }
    }
    
    func updateTimerInFirestore(boardID: UUID, timerValue: Int) {
        db.collection("boards").document(boardID.uuidString).updateData(["timerValue": timerValue]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error updating timer value: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Timer value updated successfully for board ID: \(boardID.uuidString)")
                }
            }
        }
    }
    
    func updateTimerStatusInFirestore(boardID: UUID, isPaused: Bool) {
        db.collection("boards").document(boardID.uuidString).updateData(["isPaused": isPaused]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error updating timer status: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Timer status updated successfully for board ID: \(boardID.uuidString)")
                }
            }
        }
    }
    
    func updateUsernameInFirestore(boardID: UUID, username: String) {
        guard let deviceID = UserDefaults.standard.string(forKey: "deviceID") else { return }
        db.collection("boards").document(boardID.uuidString).updateData(["usernames.\(deviceID)": username]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error updating username: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Username updated successfully for board ID: \(boardID.uuidString)")
                }
            }
        }
    }
    
    func updateDateVisibilityInFirestore(boardID: UUID, isDateVisible: Bool) {
        db.collection("boards").document(boardID.uuidString).updateData(["isDateVisible": isDateVisible]) { error in
            if let error = error {
                Crashlytics.log("Error updating isDateVisible: \(error.localizedDescription)")
            } else {
                Crashlytics.log("isDateVisible updated successfully for board ID: \(boardID.uuidString)")
            }
        }
    }
    
    func verifyPassword(boardID: UUID, enteredPassword: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("boards").document(boardID.uuidString)
        docRef.getDocument { (document, error) in
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    do {
                        let board = try document.data(as: Board.self)
                        if board.password == enteredPassword {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        Crashlytics.log("Error decoding board document: \(error.localizedDescription)")
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func setBoardExpired(boardID: UUID) {
        db.collection("boards").document(boardID.uuidString).updateData(["isExpired": true]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    Crashlytics.log("Error updating isExpired status: \(error.localizedDescription)")
                } else {
                    Crashlytics.log("Board expired status updated successfully for board ID: \(boardID.uuidString)")
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func usernameForDevice() -> String {
        return UserDefaults.standard.string(forKey: "username") ?? "Unknown User"
    }
    
    private func updateBoard(_ board: Board, completion: @escaping (Board?) -> Void) {
        do {
            let _ = try db.collection("boards").document(board.id.uuidString).setData(from: board) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        Crashlytics.log("Error updating board: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        Crashlytics.log("Board updated successfully with ID: \(board.id)")
                        completion(board)
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                Crashlytics.log("Error updating board document: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
