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

        let size = self.view?.frame.size ?? .squared(300)
        let minds = min(size.width, size.height)
        let pixelSize: CGSize = .squared(minds / CGFloat(UNIVERSE_SIZE))

        var newGraphics: [SKShapeNode] = []
        universe.cells.chunks(UNIVERSE_SIZE).enumerated().forEach({ x, cellChunk in
            cellChunk.enumerated().forEach { y, cell in
                let xPoint = (CGFloat(x) * pixelSize.width)
                let yPoint = size.height - (CGFloat(y) * pixelSize.height)
                let nodePoint = CGPoint(x: xPoint, y: yPoint)
                let node = cell.skNode(rect: CGRect(origin: nodePoint, size: pixelSize))
                node.name = "(\(x),\(y))"
                self.addChild(node)
                newGraphics.append(node)
            }
        })
        graphics = newGraphics
    }

}

extension Array {
    func chunks(_ size: Int) -> [[Element]] {
        var arr: [[Element]] = []
        var buffer: [Element] = []
        for (index, item) in self.enumerated() {
            buffer.append(item)
            if (index + 1) % size == 0 {
                arr.append(buffer)
                buffer = []
            }
        }
        return arr
    }
}
