//
//  VictoryScene.swift
//  Hopper-Rise-Up
//
//  Created by Misha Kandaurov on 15.09.2025.
//

import SpriteKit

class VictoryScene: SKScene {
    private var score: Int
    private var scoreLabel: SKLabelNode!
    private var retryButton: SKLabelNode!
    private var menuButton: SKLabelNode!
    private var victoryLabel: SKLabelNode!

    init(size: CGSize, score: Int) {
        self.score = score
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        setupBackground()
        setupVictoryLabel()
        setupButtons()
    }

    private func setupBackground() {
        backgroundColor = SKColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1.0) 
    }

    private func setupVictoryLabel() {
        victoryLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        victoryLabel.text = "YOU WON!"
        victoryLabel.fontSize = 50
        victoryLabel.fontColor = SKColor.white
        victoryLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        addChild(victoryLabel)

        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        victoryLabel.run(SKAction.repeatForever(pulse))
    }

    private func setupButtons() {
        retryButton = SKLabelNode(fontNamed: "Arial-BoldMT")
        retryButton.text = "RETRY"
        retryButton.fontSize = 35
        retryButton.fontColor = SKColor.white
        retryButton.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
        addChild(retryButton)

        menuButton = SKLabelNode(fontNamed: "Arial-BoldMT")
        menuButton.text = "MENU"
        menuButton.fontSize = 35
        menuButton.fontColor = SKColor.white
        menuButton.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        addChild(menuButton)

        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1.0)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        let blink = SKAction.sequence([fadeOut, fadeIn])

        retryButton.run(SKAction.repeatForever(blink))
        menuButton.run(SKAction.repeatForever(blink))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if retryButton.contains(location) {
            retryGame()
        } else if menuButton.contains(location) {
            goToMenu()
        }
    }

    private func retryGame() {
        let gameViewModel = GameViewModel(screenSize: size)
        let gameScene = GameScene(size: size, gameViewModel: gameViewModel)
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }

    private func goToMenu() {
        let menuViewModel = MenuViewModel()
        let menuScene = MenuScene(size: size, menuViewModel: menuViewModel)
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(menuScene, transition: transition)
    }
}
