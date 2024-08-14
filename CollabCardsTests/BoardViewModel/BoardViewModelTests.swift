//
//  BoardViewModelTests.swift
//  CollabCardsTests
//
//  Created by FFK on 14.08.2024.
//

import XCTest
@testable import CollabCards

class BoardViewModelTests: XCTestCase {

    var boardViewModel: BoardViewModel!

    override func setUpWithError() throws {
        boardViewModel = BoardViewModel()
    }

    override func tearDownWithError() throws {
        boardViewModel = nil
    }

    func testFetchBoards() {
        // Act
        boardViewModel.fetchBoards()
        
        // Assert
        XCTAssertEqual(boardViewModel.boards.count, 0, "Başlangıçta board listesi boş olmalı.")
    }
    
    func testDeleteBoardLocally() {
        // Arrange
        let board = Board(id: UUID(), name: "Test Board", deviceID: "4232BGSDV", participants: ["Test User"])
        boardViewModel.boards.append(board)
        
        // Act
        boardViewModel.deleteBoardLocally(board)
        
        // Assert
        XCTAssertFalse(boardViewModel.boards.contains(where: { $0.id == board.id }), "Board başarılı bir şekilde silinmelidir.")
    }
    
    func testDeleteBoardWithFirebase() {
        // Arrange
        let board = Board(id: UUID(), name: "Test Board", deviceID: "06947DSJds", participants: ["Test User"])
        boardViewModel.addBoard(board)
        
        let expectation = self.expectation(description: "Board silinme işlemi Firebase'de tamamlanmalıdır.")

        // Act
        boardViewModel.deleteBoard(board)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Assert
            XCTAssertFalse(self.boardViewModel.boards.contains(where: { $0.id == board.id }), "Board başarılı bir şekilde silinmelidir.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
