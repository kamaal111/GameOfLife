//
//  GameScene.swift
//  GameOfLife Shared
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import SpriteKit

class GameScene: SKScene {

    private var universe = Universe(height: 64, width: 64)

    class func newGameScene() -> GameScene {
        let scene = GameScene()
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        return scene
    }

    func setUpScene() { }

    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}
