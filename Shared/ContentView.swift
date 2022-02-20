//
//  ContentView.swift
//  Shared
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import SwiftUI
import ShrimpExtensions

struct ContentView: View {
    @StateObject private var gameOfLive = GameOfLife(
        universe: .init(height: Self.universeSize, width: Self.universeSize))

    var body: some View {
        GeometryReader { geometry in
            let size = cellSize(screenSize: geometry.size)

            VStack {
                #if !os(macOS)
                if geometry.size.height > geometry.size.width {
                    Spacer()
                        .frame(height: geometry.size.height / 4)
                }
                #endif
                HStack {
                    #if !os(macOS)
                    if geometry.size.width > geometry.size.height {
                        Spacer()
                            .frame(width: geometry.size.width / 4)
                    }
                    #endif
                    GridStack(
                        rows: gameOfLive.universe.height,
                        columns: gameOfLive.universe.width,
                        spacing: Self.gridSpacing,
                        content: { x, y in
                            CellView(
                                cell: gameOfLive.universe.getCell(x: x, y: y),
                                size: size)
                        })
                }
            }
        }
        .padding(.all, Self.paddingSize)
        #if os(macOS)
        .frame(width: Self.screenSize.width, height: Self.screenSize.height)
        #endif
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                gameOfLive.start()
            }
        })
    }

    private func cellSize(screenSize: CGSize) -> CGSize {
        #if os(macOS)
        return .squared(Self.macCellSize)
        #else
        let universeSize = CGFloat(Self.universeSize)
        var width = (screenSize.width / universeSize) - Self.gridSpacing
        var height = (screenSize.height / universeSize) - Self.gridSpacing
        if height > width {
            if width < 0 {
                width = 0
            }
            return CGSize(width: width, height: width)
        }
        if height < 0 {
            height = 0
        }
        return CGSize(width: height, height: height)
        #endif
    }

    private static let universeSize = 64
    private static let gridSpacing: CGFloat = 4
    private static let paddingSize: CGFloat = 16
    #if os(macOS)
    static let macCellSize: CGFloat = 4
    static let screenSize: CGSize = .squared((CGFloat(universeSize) * (macCellSize + gridSpacing)) + (paddingSize * 2))
    #endif
}

struct CellView: View {
    let cell: Universe.Cell
    let size: CGSize

    var body: some View {
        cell.color
            .frame(width: size.width, height: size.height)
    }
}

class GameOfLife: ObservableObject {

    @Published private(set) var universe: Universe

    init(universe: Universe) {
        self.universe = universe
    }

    func start() {
        let framePerSecond: TimeInterval = 5
        Timer.scheduledTimer(timeInterval: 1 / framePerSecond, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    @objc
    private func tick(_ timer: Timer?) {
        universe.tick()
    }

}

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
                if $0 % 2 == 0 || $0 % 7 == 0 {
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
