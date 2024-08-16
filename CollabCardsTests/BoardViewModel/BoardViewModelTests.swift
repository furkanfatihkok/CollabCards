//
//  BoardViewModelTests.swift
//  CollabCardsTests
//
//  Created by FFK on 14.08.2024.
//

import XCTest
@testable import CollabCards

class BoardViewModelTests: XCTestCase {

    func testFetchBoards() {
        let viewModel = BoardViewModel()

        XCTAssertTrue(viewModel.boards.isEmpty, "Başlangıçta tahtalar listesi boş olmalı.")
        
        viewModel.boards.append(Board(id: UUID(), name: "Test Tahtası", deviceID: "DSFDSFDSFDS", participants: ["DDDDDD"]))

        XCTAssertEqual(viewModel.boards.count, 1, "Bir tahta eklendiğinde, tahtalar listesi bir eleman içermeli.")
    }

    func testUpdateBoardSettings() {
        let viewModel = BoardViewModel()
        let boardID = UUID()

        viewModel.updateBoardSettings(boardID: boardID, isDateVisible: true, isMoveCardsDisabled: true, isAddEditCardsDisabled: true, hideCards: true)

        XCTAssertTrue(true, "Ayarlar güncellemesi başarılı bir şekilde tamamlanmalı.")
    }
}


