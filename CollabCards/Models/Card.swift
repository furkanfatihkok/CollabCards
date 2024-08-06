//
//  Card.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import Foundation

struct Card: Identifiable, Codable {
    var id: String?
    var title: String
    var status: String
    var author: String
}
