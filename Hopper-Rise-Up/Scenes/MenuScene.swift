//
//  MenuScene.swift
//  Hopper: Rise Up
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SpriteKit

class MenuScene: SKScene {
    private var menuViewModel: MenuViewModel
    private var playButton: SKLabelNode!
    private var titleLabel: SKLabelNode!
    private var coinsLabel: SKLabelNode!

    init(size: CGSize, menuViewModel: MenuViewModel) {
        self.menuViewModel = menuViewModel
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupCoinsLabel()
        setupPlayButton()
    }

    private func setupBackground() {
        backgroundColor = SKColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
    }

    private func setupTitle() {
        titleLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        titleLabel.text = "HOPPER"
        titleLabel.fontSize = 60
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        addChild(titleLabel)

        let scaleUp = SKAction.scale(to: 1.1, duration: 1.0)
        let scaleDown = SKAction.scale(to: 1.0, duration: 1.0)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        titleLabel.run(SKAction.repeatForever(pulse))
    }

    private func setupCoinsLabel() {
        coinsLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        let totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        coinsLabel.text = "Coins: \(totalCoins)"
        coinsLabel.fontSize = 30
        coinsLabel.fontColor = .yellow
        coinsLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        addChild(coinsLabel)
    }

    private func setupPlayButton() {
        playButton = SKLabelNode(fontNamed: "Arial-BoldMT")
        playButton.text = "PLAY"
        playButton.fontSize = 40
        playButton.fontColor = SKColor.white
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        addChild(playButton)

        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1.0)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        playButton.run(SKAction.repeatForever(blink))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if playButton.contains(location) {
            startGame()
        }
    }

    private func startGame() {
        menuViewModel.startGame()

        let gameViewModel = GameViewModel(screenSize: size)
        let gameScene = GameScene(size: size, gameViewModel: gameViewModel)
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }
}
