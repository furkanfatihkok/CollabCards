//
//  BoardViewModel.swift
//  CollabCards
//
//  Created by FFK on 2.08.2024.
//

import Foundation
import FirebaseFirestore

class BoardViewModel: ObservableObject {
    @Published var boards = [Board]()
    private var db = Firestore.firestore()
    
    func fetchBoards() {
        db.collection("boards").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching boards: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.boards = documents.compactMap { queryDocumentSnapshot in
                do {
                    let board = try queryDocumentSnapshot.data(as: Board.self)
                    return board
                } catch {
                    print("Error decoding document into Board: \(error.localizedDescription)")
                    print("Document data: \(queryDocumentSnapshot.data())")
                    return nil
                }
            }
        }
    }
    
    func addBoard(_ board: Board) {
        do {
            let _ = try db.collection("boards").document(board.id.uuidString).setData(from: board) { error in
                if let error = error {
                    print("Error adding board: \(error.localizedDescription)")
                } else {
                    print("Board added successfully")
                }
            }
        } catch {
            print("Error creating board document: \(error.localizedDescription)")
        }
    }
    
    func deleteBoard(_ board: Board) {
        db.collection("boards").document(board.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting board: \(error.localizedDescription)")
            } else {
                print("Board deleted successfully")
            }
        }
    }
}
