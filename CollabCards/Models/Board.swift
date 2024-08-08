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
    var deviceID: String
    var participants: [String]
    var timerValue: Int?
    var isPaused: Bool?
    var isExpired: Bool?
    var isAnonymous: Bool?
    var usernames: [String: String]? 
    var password: String?
}






