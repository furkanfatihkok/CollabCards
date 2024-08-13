//
//  Board.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import Foundation

struct Board: Identifiable, Codable {
    var id: UUID
    var name: String
    var password: String?
    var deviceID: String
    var participants: [String]
    var timerValue: Int?
    var isPaused: Bool?
    var isExpired: Bool?
    var isDateVisible: Bool? = false
    var isMoveCardsDisabled: Bool? = false
    var isAddEditCardsDisabled: Bool? = false
    var usernames: [String: String]?
}






