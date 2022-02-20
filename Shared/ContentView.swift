//
//  ContentView.swift
//  Shared
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameOfLive = GameOfLife(universe: .init(rows: 4, columns: 4))

    var body: some View {
        GridStack(rows: gameOfLive.universe.rows, columns: gameOfLive.universe.columns, content: { row, column in
            Button(action: { gameOfLive.activateCell(row: row, column: column) }, label: {
                gameOfLive.universe.cellIsAlive(row: row, column: column) ? Color.black : Color.white
            })
                .buttonStyle(.plain)
        })
            .frame(minWidth: 300, minHeight: 300)
    }
}

class GameOfLife: ObservableObject {

    @Published private(set) var universe: Universe

    init(universe: Universe) {
        self.universe = universe
    }

    func activateCell(row: Int, column: Int) {
        withAnimation(.easeOut(duration: 0.2)) {
            universe.activateCell(row: row, column: column)
        }
    }

}

struct Universe {
    let rows: Int
    let columns: Int
    private var cells: [Cell]

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.cells = [Cell](repeating: .dead, count: rows * columns)
    }

    enum Cell: UInt8 {
        case dead = 0
        case alive = 1
    }

    func cellIsAlive(row: Int, column: Int) -> Bool {
        cells[index(row: row, column: column)] == .alive
    }

    mutating func activateCell(row: Int, column: Int) {
        cells[index(row: row, column: column)] = .alive
    }

    private func index(row: Int, column: Int) -> Int {
        row * columns + column
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
