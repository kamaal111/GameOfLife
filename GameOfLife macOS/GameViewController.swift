//
//  GameViewController.swift
//  GameOfLife macOS
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene.newGameScene()
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}
