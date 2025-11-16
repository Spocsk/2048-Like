//
//  GameViewModel.swift
//  2048
//
//  Created by Dylan on 10/11/2025.
//

import Combine
import Foundation
import SwiftUI

class GameViewModel: ObservableObject {

    @Published var gridSize: Int = 4
    @Published var tileGrid: [[Tile]] = []

    init(gridSize: Int = 4) {
        self.gridSize = gridSize
        self.tileGrid = self.createTileGrid()
        print(self.tileGrid)
    }

    func getAllTiltes() -> [Tile] {
        self.tileGrid.flatMap(\.self)
    }

    func createTileGrid() -> [[Tile]] {
        return (0..<self.gridSize).compactMap { row in
            (0..<self.gridSize).map { col in
                Tile(
                    id: UUID(),
                    value: 0,
                    position: Position(row: row, col: col),
                    isEmpty: true
                )
            }
        }

    }

    func resetGame() {
        self.tileGrid = self.createTileGrid()
    }

    func updateTile(_ tile: Tile) {
        guard tile.position.row >= 0,
            tile.position.col >= 0,
            tile.position.row < self.gridSize,
            tile.position.col < self.gridSize
        else { return }
        self.tileGrid[tile.position.row][tile.position.col] = tile
    }

    func isTilesMergeable(at tile: Tile, with otherTile: Tile) -> Bool {
        if !tile.isEmpty && otherTile.value == tile.value {
            return true
        }
        print("Not mergeable !")
        print("Tile data: \(tile)")
        print("Other tile data: \(otherTile)")
        return false
    }

    private func isTileEmpty(at position: Position) -> Bool {
        guard position.row >= 0,
            position.col >= 0,
            position.row < self.gridSize,
            position.col < self.gridSize
        else { return false }
        return self.tileGrid[position.row][position.col].isEmpty
    }

    // Compress a sequence of tiles to remove empties while preserving order
    private func compressedTiles(from tiles: [Tile]) -> [Tile] {
        return tiles.filter { !$0.isEmpty }
    }

    // Merge values according to 2048 rules (single merge per pair, left-to-right in the given order)
    private func mergedTiles(from tiles: [Tile]) -> [Tile] {
        var result: [Tile] = []
        var skipNext = false
        for i in 0..<tiles.count {
            if skipNext {
                skipNext = false
                continue
            }
            if i + 1 < tiles.count, tiles[i].value == tiles[i + 1].value {
                result.append(
                    Tile(
                        id: tiles[i].id,
                        value: tiles[i].value * 2,
                        position: tiles[i].position,
                        isEmpty: false
                    )
                )
                skipNext = true
            } else {
                result.append(tiles[i])
            }
        }
        return result
    }

    // Rebuild a line of tiles from merged values, padding with empties to fit gridSize
    private func rebuildLine(
        from originalTiles: [Tile],
        positions: [Position]
    ) -> [Tile] {
        var tiles: [Tile] = []
        var idx = 0
        for pos in positions {
            if idx < originalTiles.count {
                tiles.append(
                    Tile(
                        id: originalTiles[idx].id,
                        value: originalTiles[idx].value,
                        position: pos,
                        isEmpty: false
                    )
                )
                idx += 1
            } else {
                tiles.append(
                    Tile(id: UUID(), value: 0, position: pos, isEmpty: true)
                )
            }
        }
        return tiles
    }

    func moveTile(direction: GestureDirection) {
        // For each direction, process rows/columns in the correct order
        let size = self.gridSize
        switch direction {
        case .left:
            for row in 0..<size {
                let originalLine = self.tileGrid[row]
                let positions = (0..<size).map { Position(row: row, col: $0) }
                let values = compressedTiles(from: originalLine)
                let merged = mergedTiles(from: values)
                let rebuilt = rebuildLine(
                    from: merged,
                    positions: positions
                )
                self.tileGrid[row] = rebuilt
            }
        case .right:
            for row in 0..<size {
                let originalLine = self.tileGrid[row].reversed()
                let positions = (0..<size).map {
                    Position(row: row, col: size - 1 - $0)
                }  // right to left positions
                let values = compressedTiles(from: Array(originalLine))
                let merged = mergedTiles(from: values)
                let rebuilt = rebuildLine(
                    from: merged,
                    positions: positions
                )
                self.tileGrid[row] = rebuilt.reversed()
            }
        case .up:
            for col in 0..<size {
                let originalLine = (0..<size).map { self.tileGrid[$0][col] }
                let positions = (0..<size).map { Position(row: $0, col: col) }
                let values = compressedTiles(from: originalLine)
                let merged = mergedTiles(from: values)
                let rebuilt = rebuildLine(
                    from: merged,
                    positions: positions
                )
                for r in 0..<size {
                    self.tileGrid[r][col] = rebuilt[r]
                }
            }
        case .down:
            for col in 0..<size {
                let originalLine = (0..<size).map { self.tileGrid[$0][col] }
                    .reversed()
                let positions = (0..<size).map {
                    Position(row: size - 1 - $0, col: col)
                }  // bottom to top positions
                let values = compressedTiles(from: Array(originalLine))
                let merged = mergedTiles(from: values)
                let rebuilt = rebuildLine(
                    from: merged,
                    positions: positions
                )
                for r in 0..<size {
                    self.tileGrid[size - 1 - r][col] = rebuilt[r]
                }
            }
        }
    }

    func createRandomTile() {
        let randomRowIndex = Int.random(in: 0..<self.gridSize)
        let randomColIndex = Int.random(in: 0..<self.gridSize)

        if self.tileGrid[randomRowIndex][randomColIndex].isEmpty {
            let tile = Tile(
                id: UUID(),
                value: 2,
                position: Position(row: randomRowIndex, col: randomColIndex),
                isEmpty: false
            )
            self.updateTile(tile)
        }
    }

    func getColorFromTileValue(_ value: Int) -> Color {
        switch value {
        case 2:
            return Color(
                red: 238.0 / 255.0,
                green: 228.0 / 255.0,
                blue: 218.0 / 255.0
            )
        case 4:
            return Color(
                red: 237.0 / 255.0,
                green: 224.0 / 255.0,
                blue: 200.0 / 255.0
            )
        case 8:
            return Color(
                red: 242.0 / 255.0,
                green: 177.0 / 255.0,
                blue: 121.0 / 255.0
            )
        case 16:
            return Color(
                red: 245.0 / 255.0,
                green: 124.0 / 255.0,
                blue: 95.0 / 255.0
            )
        case 32:
            return Color(
                red: 246.0 / 255.0,
                green: 84.0 / 255.0,
                blue: 54.0 / 255.0
            )
        case 64:
            return Color(
                red: 237.0 / 255.0,
                green: 207.0 / 255.0,
                blue: 115.0 / 255.0
            )
        case 128:
            return Color(
                red: 237.0 / 255.0,
                green: 204.0 / 255.0,
                blue: 97.0 / 255.0
            )
        case 256:
            return Color(
                red: 237.0 / 255.0,
                green: 200.0 / 255.0,
                blue: 80.0 / 255.0
            )
        case 512:
            return Color(
                red: 237.0 / 255.0,
                green: 197.0 / 255.0,
                blue: 60.0 / 255.0
            )
        case 1024:
            return Color(
                red: 237.0 / 255.0,
                green: 194.0 / 255.0,
                blue: 43.0 / 255.0
            )
        case 2048:
            return Color(
                red: 237.0 / 255.0,
                green: 191.0 / 255.0,
                blue: 26.0 / 255.0
            )
        default:
            return Color.gray
        }
    }

    func isGameOver() -> Bool {
        return self.tileGrid.flatMap { $0 }.contains(where: { $0.value == 2048 }
        )
    }

}
