//
//  Simulation.swift
//  GameOfLife
//
//  Created by Kamaal M Farah on 26/02/2022.
//

import Foundation

final class Simulation: ObservableObject {

    @Published private(set) var universe: Universe
    @Published private var currentTimer: Timer?
    @Published var pointerMode: PointerMode = .singleCell

    init(universe: Universe) {
        self.universe = universe
    }

    enum PointerMode: CaseIterable {
        case singleCell

        var string: String {
            Self.stringMapping[self]!
        }

        private static let stringMapping: [PointerMode: String] = [
            .singleCell: "Single Cell"
        ]
    }

    var isPaused: Bool { currentTimer == nil }

    func togglePlay() {
        if isPaused {
            play()
        } else {
            pause()
        }
    }

    func pause() {
        currentTimer?.invalidate()
        currentTimer = nil
    }

    func play() {
        guard isPaused else { return }
        let framePerSecond: TimeInterval = 5
        currentTimer = Timer.scheduledTimer(
            timeInterval: 1 / framePerSecond,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true)
    }

    func toggleCell(x: Int, y: Int) {
        switch pointerMode {
        case .singleCell: universe.toggleCell(x: x, y: y)
        }
    }

    func killAllCells() {
        pause()
        universe.killAllCells()
    }

    func randomizeCells() {
        pause()
        universe.randomizeCells()
        tick(nil)
    }

}

extension Simulation {
    @objc
    private func tick(_ timer: Timer?) {
        universe.tick()
    }
}
