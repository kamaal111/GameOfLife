//
//  Universe.swift
//  GameOfLife
//
//  Created by Kamaal M Farah on 26/02/2022.
//

import SwiftUI

struct Universe {
    let height: Int
    let width: Int
    private(set) var cells: [Cell]

    private init(height: Int, width: Int, cells: [Cell]) {
        self.height = height
        self.width = width
        self.cells = cells
    }

    init(height: Int, width: Int) {
        let cells: [Cell] = (0..<(height * width)).map({ _ in Bool.random() ? .alive : .dead })
        self.init(height: height, width: width, cells: cells)
    }

    enum Cell: UInt8 {
        case dead = 0
        case alive = 1

        var isAlive: Bool { self == .alive }
        var color: Color { isAlive ? .black : .white }
        var int: Int { isAlive ? 1 : 0 }

        fileprivate mutating func toggle() {
            self = isAlive ? .dead : .alive
        }
    }

    mutating func tick() {
        var next = cells

        for x in 0..<height {
            for y in 0..<width {
                let cell = getCell(x: x, y: y)
                let liveNeighbors = liveNeighborCount(x: x, y: y)

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

                let index = getIndex(x: x, y: y)
                next[index] = nextCell
            }
        }

        self.cells = next
    }

    mutating func toggleCell(x: Int, y: Int) {
        cells[getIndex(x: x, y: y)].toggle()
    }

    mutating func killAllCells() {
        cells = cells.map({ _ in .dead })
    }

    mutating func randomizeCells() {
        cells = cells.map({ _ in Bool.random() ? .alive : .dead })
    }

    func getCell(x: Int, y: Int) -> Cell {
        cells[getIndex(x: x, y: y)]
    }
}

extension Universe {
    private func liveNeighborCount(x: Int, y: Int) -> Int {
        var count = 0

        let north = x == 0 ? (height - 1) : (x - 1)
        let south = x == (height - 1) ? 0 : (x + 1)
        let west = y == 0 ? (width - 1) : (y - 1)
        let east = y == (width - 1) ? 0 : (y + 1)

        let nw = getCell(x: north, y: west)
        count += nw.int
        let n = getCell(x: north, y: y)
        count += n.int
        let ne = getCell(x: north, y: east)
        count += ne.int
        let w = getCell(x: x, y: west)
        count += w.int
        let e = getCell(x: x, y: east)
        count += e.int
        let sw = getCell(x: south, y: west)
        count += sw.int
        let s = getCell(x: south, y: y)
        count += s.int
        let se = getCell(x: south, y: east)
        count += se.int

        return count
    }

    private func getIndex(x: Int, y: Int) -> Int {
        x * width + y
    }
}
