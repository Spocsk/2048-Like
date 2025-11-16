//
//  GameModel.swift
//  2048
//
//  Created by Dylan on 11/11/2025.
//

import Foundation

enum GestureDirection: String, CaseIterable, Codable {
    case up, down, left, right
}

struct Position: Hashable, Codable {
    var row: Int
    var col: Int
}

struct Tile: Identifiable, Codable, Hashable {
    let id: UUID
    var value: Int
    var position: Position
    var isEmpty: Bool

    mutating func updateValue(by newValue: Int) -> Void {
        self.value = newValue
    }

    mutating func updatePosition(by newPosition: Position) -> Void {
        self.position = newPosition
    }

    mutating func updateIsEmpty(by isEmpty: Bool) -> Void {
        self.isEmpty = isEmpty
    }
    
    mutating func reset() -> Void {
        self.value = 0
        self.isEmpty = true
    }
}
