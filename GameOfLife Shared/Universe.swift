//
//  Universe.swift
//  GameOfLife
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import Foundation
#if canImport(SpriteKit)
import SpriteKit
#endif

struct Universe {
    let height: Int
    let width: Int
    private var cells: [Cell]

    private init(height: Int, width: Int, cells: [Cell]) {
        self.height = height
        self.width = width
        self.cells = cells
    }

    init(height: Int, width: Int) {
        let cells: [Cell] = (0..<(height * width))
            .map({
                if ($0 % 2) == 0 || ($0 % 7) == 0 {
                    return .alive
                }
                return .dead
            })
        self.init(height: height, width: width, cells: cells)
    }

    enum Cell: UInt8 {
        case dead = 0
        case alive = 1

        var isAlive: Bool { self == .alive }
        #if canImport(SpriteKit)
        var color: SKColor { isAlive ? .black : .white }

        func skNode(rect: CGRect) -> SKShapeNode {
            let node = SKShapeNode(rect: rect)
            node.fillColor = .red
            node.strokeColor = .clear
            return node
        }
        #endif
    }

    mutating func tick() {
        var next = cells

        for row in 0..<height {
            for column in 0..<width {
                let cell = getCell(x: row, y: column)
                let liveNeighbors = liveNeighborCount(x: row, y: column)

                let nextCell: Cell
                switch (cell, liveNeighbors) {
                    // Rule 1: Any live cell with fewer than two live neighbors
                    // dies, as if caused by underpopulation.
                case (.alive, let x) where x < 2: nextCell = .dead
                    // Rule 2: Any live cell with two or three live neighbors
                    // lives on to the next generation.
                case (.alive, 2), (.alive, 3): nextCell = .alive
                    // Rule 3: Any live cell with more than three live
                    // neighbors dies, as if by overpopulation.
                case (.alive, let x) where x > 3: nextCell = .dead
                    // Rule 4: Any dead cell with exactly three live neighbors
                    // becomes a live cell, as if by reproduction.
                case (.dead, 3): nextCell = .alive
                    // All other cells remain in the same state.
                default: nextCell = cell
                }

                let index = getIndex(x: row, y: column)
                next[index] = nextCell
            }
        }

        self.cells = next
    }

    func getCell(x: Int, y: Int) -> Cell {
        cells[getIndex(x: x, y: y)]
    }

    private func liveNeighborCount(x: Int, y: Int) -> Int {
        var count = 0
        for deltaRow in [(height - 1), 0, 1] {
            for deltaColumn in [(width - 1), 0, 1] {
                if deltaRow == 0 && deltaColumn == 0 {
                    continue
                }

                let neighborRow = (x + deltaRow) % height
                let neighborColumn = (y + deltaColumn) % width
                if getCell(x: neighborRow, y: neighborColumn).isAlive {
                    count += 1
                }
            }
        }
        return count
    }

    private func getIndex(x: Int, y: Int) -> Int {
        x * width + y
    }
}
