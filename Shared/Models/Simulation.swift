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

    init(universe: Universe) {
        self.universe = universe
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
