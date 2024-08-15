//
//  CardViewModelTests.swift
//  CollabCardsTests
//
//  Created by FFK on 14.08.2024.
//

import XCTest
@testable import CollabCards

class CardViewModelTests: XCTestCase {

    func testFetchCards() {
        let viewModel = CardViewModel()

        XCTAssertTrue(viewModel.cards.isEmpty, "Başlangıçta kartlar listesi boş olmalı.")

        viewModel.cards.append(Card(id: UUID(), title: "Test Kartı", status: "Yapılacak", author: "Test Yazar", date: Date()))

        XCTAssertEqual(viewModel.cards.count, 1, "Bir kart eklendiğinde, kartlar listesi bir eleman içermeli.")
    }

    func testDeleteCard() {
        let viewModel = CardViewModel()
        let testCard = Card(id: UUID(), title: "Silinecek Kart", status: "Yapılacak", author: "Test Yazar", date: Date())
        
        viewModel.cards.append(testCard)
        XCTAssertEqual(viewModel.cards.count, 1, "Kart eklendiğinde kartlar listesi bir eleman içermeli.")

        viewModel.deleteCard(testCard, from: "testBoardID")
        viewModel.cards.removeAll { $0.id == testCard.id }

        XCTAssertTrue(viewModel.cards.isEmpty, "Kart silindikten sonra kartlar listesi boş olmalı.")
    }
}
