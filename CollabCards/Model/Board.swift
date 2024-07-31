//
//  Board.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import Foundation
import SwiftData

@Model
class Board {
    @Attribute(.unique) var id: UUID
    @Attribute var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}


