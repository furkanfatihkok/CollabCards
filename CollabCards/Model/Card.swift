//
//  Card.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import Foundation
import FirebaseFirestore

struct Card: Identifiable, Codable {
    var id: String?
    var title: String
    var description: String
    var status: String
}
