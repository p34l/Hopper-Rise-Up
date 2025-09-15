//
//  GameScene.swift
//  Hopper: Rise Up
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SpriteKit

class GameScene: SKScene {
    private var gameViewModel: GameViewModel
    private var playerNode: SKSpriteNode!
    private var platformNodes: [SKSpriteNode] = []
    private var coinNodes: [SKSpriteNode] = []
    private var scoreLabel: SKLabelNode!
    private var lastUpdateTime: TimeInterval = 0
    private var didMoveCameraUp = false

    init(size: CGSize, gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        setupBackground()
        setupPlayer()
        setupScoreLabel()
        setupPlatforms()
        setupCoins()
    }

    private func setupBackground() {
        backgroundColor = SKColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
    }

    private func setupPlayer() {
        playerNode = SKSpriteNode(color: SKColor.red, size: CGSize(width: 40, height: 40))
        playerNode.position = gameViewModel.getPlayerPosition()
        addChild(playerNode)
    }

    private func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: 100, y: size.height - 50)
        addChild(scoreLabel)
    }

    private func setupPlatforms() {
        for platform in gameViewModel.platforms {
            let platformNode = SKSpriteNode(color: SKColor.brown, size: platform.size)
            platformNode.position = platform.position
            addChild(platformNode)
            platformNodes.append(platformNode)
        }
    }

    private func setupCoins() {
        for coin in gameViewModel.coins {
            let coinNode = SKSpriteNode(color: SKColor.yellow, size: coin.size)
            coinNode.position = coin.position
            addChild(coinNode)
            coinNodes.append(coinNode)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        gameViewModel.update(currentTime: currentTime)

        updatePlayerPosition()
        updateScore()
        updatePlatforms()
        updateCoins()

        if gameViewModel.gameState == .gameOver {
            showGameOverScene()
        }

        if gameViewModel.score >= 50 {
            showVictoryScene()
        }
    }

    private func updatePlayerPosition() {
        let playerPos = gameViewModel.getPlayerPosition()
        playerNode.position = playerPos

        if playerNode.position.y > size.height / 2 {
            let deltaY = playerNode.position.y - size.height / 2
            didMoveCameraUp = true

            for (index, platform) in gameViewModel.platforms.enumerated() {
                platform.position.y -= deltaY

                if index < platformNodes.count {
                    platformNodes[index].position.y = platform.position.y
                } else {
                    let platformNode = SKSpriteNode(color: SKColor.brown, size: platform.size)
                    platformNode.position = platform.position
                    addChild(platformNode)
                    platformNodes.append(platformNode)
                }
            }

            for (index, coin) in gameViewModel.coins.enumerated() {
                coin.position.y -= deltaY

                if index < coinNodes.count {
                    coinNodes[index].position.y = coin.position.y
                } else {
                    let coinNode = SKSpriteNode(color: SKColor.yellow, size: coin.size)
                    coinNode.position = coin.position
                    addChild(coinNode)
                    coinNodes.append(coinNode)
                }
            }

            playerNode.position.y -= deltaY
            gameViewModel.player.position.y -= deltaY
        }

        if didMoveCameraUp && playerNode.position.y == 0 {
            gameViewModel.gameState = .gameOver
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if location.x < size.width / 2 {
            gameViewModel.movePlayerLeft()
        } else {
            gameViewModel.movePlayerRight()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameViewModel.stopPlayer()
    }

    private func updateScore() {
        scoreLabel.text = "Score: \(gameViewModel.score)"
    }

    private func updatePlatforms() {
        for (index, platform) in gameViewModel.platforms.enumerated() {
            if !platform.isActive {
                platformNodes[index].removeFromParent()
            }
        }

        while platformNodes.count < gameViewModel.platforms.count {
            let platform = gameViewModel.platforms[platformNodes.count]
            let platformNode = SKSpriteNode(color: SKColor.brown, size: platform.size)
            platformNode.position = platform.position
            addChild(platformNode)
            platformNodes.append(platformNode)
        }
    }

    private func updateCoins() {
        for node in coinNodes {
            node.removeFromParent()
        }
        coinNodes.removeAll()

        for coin in gameViewModel.coins {
            let coinNode = SKSpriteNode(color: SKColor.yellow, size: coin.size)
            coinNode.position = coin.position
            addChild(coinNode)
            coinNodes.append(coinNode)
        }
    }

    private func showGameOverScene() {
        gameViewModel.saveCollectedCoins()
        let gameOverScene = GameOverScene(size: size, score: gameViewModel.score)
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameOverScene, transition: transition)
    }

    private func showVictoryScene() {
        gameViewModel.saveCollectedCoins()
        let victoryScene = VictoryScene(size: size, score: gameViewModel.score)
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(victoryScene, transition: transition)
    }
}
