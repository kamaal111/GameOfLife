//
//  ContentView.swift
//  Shared
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameOfLive = GameOfLife(universe: .init(height: 5, width: 5))

    var body: some View {
        GridStack(rows: gameOfLive.universe.height, columns: gameOfLive.universe.width, content: { x, y in
            CellView(cell: gameOfLive.universe.getCell(x: x, y: y))
        })
            .frame(minWidth: 300, minHeight: 300)
    }
}

struct CellView: View {
    let cell: Universe.Cell

    var body: some View {
        ZStack {
            cell.color
        }
    }
}

class GameOfLife: ObservableObject {

    @Published private(set) var universe: Universe

    init(universe: Universe) {
        self.universe = universe
    }

}

struct Universe {
    let height: Int
    let width: Int
    private var cells: [Cell]

    init(height: Int, width: Int) {
        self.height = height
        self.width = width
        self.cells = [Cell](repeating: .dead, count: height * width)
    }

    enum Cell: UInt8 {
        case dead = 0
        case alive = 1

        var isAlive: Bool { self == .alive }
        var color: Color { isAlive ? .black : .white }
    }

    mutating func tick() {
        var next = cells

        for row in 0..<height {
            for column in 0..<width {
                let index = getIndex(x: row, y: column)
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

                next[index] = nextCell
            }
        }

        self.cells = next
    }

    func getCell(x: Int, y: Int) -> Cell {
        cells[getIndex(x: x, y: y)]
    }

    private mutating func activateCell(x: Int, y: Int) {
        cells[getIndex(x: x, y: y)] = .alive
    }

    private func liveNeighborCount(x: Int, y: Int) -> Int {
        var count = 0
        for deltaRow in [height - 1, 0, 1] {
            for deltaColumn in [width - 1, 0, 1] {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
