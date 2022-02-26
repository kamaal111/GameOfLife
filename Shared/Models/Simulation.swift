//
//  Simulation.swift
//  GameOfLife
//
//  Created by Kamaal M Farah on 26/02/2022.
//

import Foundation

final class Simulation: ObservableObject {

    @Published private(set) var universe: Universe

    init(universe: Universe) {
        self.universe = universe
    }

    func start() {
        let framePerSecond: TimeInterval = 5
        Timer.scheduledTimer(
            timeInterval: 1 / framePerSecond,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true)
    }

    @objc
    private func tick(_ timer: Timer?) {
        universe.tick()
    }

}
