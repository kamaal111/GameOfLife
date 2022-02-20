//
//  GameScene.swift
//  GameOfLife Shared
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import SpriteKit
import ShrimpExtensions

private let UNIVERSE_SIZE = 4

class GameScene: SKScene {

    private var universe = Universe(height: UNIVERSE_SIZE, width: UNIVERSE_SIZE)
    private var graphics = [SKShapeNode?](repeating: nil, count: UNIVERSE_SIZE * UNIVERSE_SIZE)

    class func newGameScene() -> GameScene {
        let scene = GameScene()
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        return scene
    }

    func setUpScene() {
        initializeGrid()
    }

    #if os(watchOS)
    override func sceneDidLoad() {
        setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        setUpScene()
    }
    #endif

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    private func initializeGrid() {
        graphics.forEach({
            $0?.removeFromParent()
        })

        let pixelSize: CGSize = .squared(20)
        let size = self.view?.frame.size ?? .squared(300)

        for x in 0..<UNIVERSE_SIZE {
            for y in 0..<UNIVERSE_SIZE {
                let xPoint = (CGFloat(x) * pixelSize.width)
                let yPoint = size.height - (CGFloat(y) * pixelSize.height)
                let nodePoint = CGPoint(x: xPoint, y: yPoint)
                let cell = universe.getCell(x: x, y: y)
                let node = cell.skNode(rect: CGRect(origin: nodePoint, size: pixelSize))

                self.addChild(node)
                graphics[x * UNIVERSE_SIZE + y] = node
            }
        }
    }

}
