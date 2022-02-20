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
            Button(action: { gameOfLive.activateCell(x: x, y: y) }, label: {
                CellView(
                    isAlive: gameOfLive.universe.cellIsAlive(x: x, y: y),
                    liveNeighborCount: gameOfLive.universe.liveNeighborCount(x: x, y: y))
            })
                .buttonStyle(.plain)
        })
            .frame(minWidth: 300, minHeight: 300)
    }
}

struct CellView: View {
    let isAlive: Bool
    let liveNeighborCount: Int

    var body: some View {
        ZStack {
            isAlive ? Color.black : Color.white
            Text("\(liveNeighborCount)")
                .foregroundColor(isAlive ? Color.white : Color.black)
        }
    }
}

class GameOfLife: ObservableObject {

    @Published private(set) var universe: Universe

    init(universe: Universe) {
        self.universe = universe
    }

    func activateCell(x: Int, y: Int) {
        withAnimation(.easeOut(duration: 0.2)) {
            universe.activateCell(x: x, y: y)
        }
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
    }

    func cellIsAlive(x: Int, y: Int) -> Bool {
        cells[getIndex(x: x, y: y)] == .alive
    }

    func liveNeighborCount(x: Int, y: Int) -> Int {
        var count = 0
        for deltaRow in [height - 1, 0, 1] {
            for deltaColumn in [width - 1, 0, 1] {
                if deltaRow == 0 && deltaColumn == 0 {
                    continue
                }

                let neighborRow = (x + deltaRow) % height
                let neighborColumn = (y + deltaColumn) % width
                if cellIsAlive(x: neighborRow, y: neighborColumn) {
                    count += 1
                }
            }
        }
        return count
    }

    mutating func activateCell(x: Int, y: Int) {
        cells[getIndex(x: x, y: y)] = .alive
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
