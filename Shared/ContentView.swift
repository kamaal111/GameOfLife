//
//  ContentView.swift
//  Shared
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import SwiftUI
import Python

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
    private var representation: [UInt8]

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.representation = [UInt8](repeating: 0, count: rows * columns)
    }

    func cellIsAlive(row: Int, column: Int) -> Bool {
        let item = representation[index(row: row, column: column)]
        return item == 1
    }

    mutating func activateCell(row: Int, column: Int) {
        representation[index(row: row, column: column)] = 1
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
