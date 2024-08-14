//
//  CardViewModelTests.swift
//  CollabCardsTests
//
//  Created by FFK on 14.08.2024.
//

import XCTest
@testable import CollabCards

class CardViewModelTests: XCTestCase {

    var cardViewModel: CardViewModel!

    override func setUpWithError() throws {
        cardViewModel = CardViewModel()
    }

    override func tearDownWithError() throws {
        cardViewModel = nil
    }

    func testFetchCards() {
        // Act
        cardViewModel.fetchCards(for: "testBoardID")
        
        // Assert
        XCTAssertEqual(cardViewModel.cards.count, 0, "Başlangıçta kart listesi boş olmalı.")
    }

    func testAddCard() {
        // Arrange
        let card = Card(id: UUID(), title: "Test Card", status: "To Do", author: "Test User", date: Date())
        
        let expectation = self.expectation(description: "Card should be added to the cards array")
        
        // Act
        cardViewModel.addCard(card, to: "testBoardID") {
            // Assert
            XCTAssertTrue(self.cardViewModel.cards.contains(where: { $0.id == card.id }), "Kart başarılı bir şekilde eklenmelidir.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDeleteCard() {
        // Arrange
        let card = Card(id: UUID(), title: "Test Card", status: "To Do", author: "Test User", date: Date())
        cardViewModel.cards.append(card)
        
        let expectation = self.expectation(description: "Card should be deleted from the cards array")
        
        // Act
        cardViewModel.deleteCard(card, from: "testBoardID")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Assert
            XCTAssertFalse(self.cardViewModel.cards.contains(where: { $0.id == card.id }), "Kart başarılı bir şekilde silinmelidir.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
