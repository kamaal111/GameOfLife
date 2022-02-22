//
//  GameScene.swift
//  GameOfLife Shared
//
//  Created by Kamaal M Farah on 20/02/2022.
//

import SpriteKit
import ShrimpExtensions

class GameScene: SKScene {

    private var universe = Universe(height: Constants.universeSize, width: Constants.universeSize)
    private var graphics = [SKShapeNode?](repeating: nil, count: Int(pow(Double(Constants.universeSize), 2)))

    private override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public class func newGameScene(size: CGSize) -> GameScene {
        GameScene(size: size)
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
//        universe.cells.enumerated().forEach({ index, cell in
//            graphics[index]?.fillColor = [SKColor.red, SKColor.blue].randomElement()!
//        })
    }

    private func initializeGrid() {
        graphics.forEach({
            $0?.removeFromParent()
        })

        let size = self.view?.frame.size ?? .squared(300)
        self.view?.scene?.backgroundColor = .brown
        let minds = min(size.width, size.height)
        let pixelSize: CGSize = .squared(minds / CGFloat(Constants.universeSize))

        var newGraphics: [SKShapeNode] = []
        universe.cells
            .chunks(Constants.universeSize)
            .enumerated()
            .forEach({ x, cellChunk in
                cellChunk
                    .enumerated()
                    .forEach { y, cell in
                        let xPoint = (CGFloat(x) * pixelSize.width)
                        let yPoint = size.height - (CGFloat(y) * pixelSize.height)
                        let nodePoint = CGPoint(x: xPoint, y: yPoint)
                        let nodeRect = CGRect(origin: nodePoint, size: pixelSize)
//                        let node = cell.skNode(rect: nodeRect)
                        let node = SKShapeNode(rect: nodeRect)
                        node.fillColor = cell.color
                        node.name = "(\(x),\(y))"
                        self.addChild(node)
                        newGraphics.append(node)
                    }
            })
        graphics = newGraphics
        graphics.forEach({ node in
            print(node)
        })
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
