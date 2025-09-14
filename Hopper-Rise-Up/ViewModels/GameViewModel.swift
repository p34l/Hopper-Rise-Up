//
//  GameViewModel.swift
//  Hopper: Rise Up
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import Foundation
import SpriteKit

class GameViewModel: ObservableObject {
    @Published var gameState: GameState = .playing
    @Published var score: Int = 0
    @Published var platforms: [Platform] = []
    @Published var coins: [Coin] = []

    private var player: Player
    private var lastUpdateTime: TimeInterval = 0
    private let screenWidth: CGFloat
    private let screenHeight: CGFloat

    init(screenSize: CGSize) {
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        player = Player(position: CGPoint(x: screenWidth / 2, y: 100))
        generateInitialLevel()
    }

    func update(currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }

        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        player.update(deltaTime: deltaTime)

        checkPlatformCollisions()

        checkCoinCollection()

        generateNewElements()

        checkGameOver()
    }

    func playerJump() {
        player.jump()
    }

    func getPlayerPosition() -> CGPoint {
        return player.position
    }

    private func checkPlatformCollisions() {
        for platform in platforms {
            if platform.isPlayerOnPlatform(player: player) {
                player.position.y = platform.position.y + platform.size.height / 2 + player.size.height / 2
                player.velocity.y = 0
                player.isJumping = false
                break
            }
        }
    }

    private func checkCoinCollection() {
        for coin in coins {
            if !coin.isCollected && coin.isPlayerCollecting(player: player) {
                coin.collect()
                score += coin.value
            }
        }
    }

    private func generateInitialLevel() {
        for i in 0 ..< 5 {
            let x = CGFloat.random(in: 50 ... (screenWidth - 50))
            let y = CGFloat(150 + i * 100)
            let platform = Platform(position: CGPoint(x: x, y: y))
            platforms.append(platform)
        }

        for i in 0 ..< 3 {
            let x = CGFloat.random(in: 50 ... (screenWidth - 50))
            let y = CGFloat(200 + i * 150)
            let coin = Coin(position: CGPoint(x: x, y: y))
            coins.append(coin)
        }
    }

    private func generateNewElements() {
        if platforms.isEmpty || platforms.last!.position.y < screenHeight + 200 {
            let x = CGFloat.random(in: 50 ... (screenWidth - 50))
            let y = (platforms.last?.position.y ?? 0) + CGFloat.random(in: 80 ... 120)
            let platform = Platform(position: CGPoint(x: x, y: y))
            platforms.append(platform)
        }

        if coins.count < 5 {
            let x = CGFloat.random(in: 50 ... (screenWidth - 50))
            let y = CGFloat.random(in: 200 ... (screenHeight + 100))
            let coin = Coin(position: CGPoint(x: x, y: y))
            coins.append(coin)
        }
    }

    private func checkGameOver() {
        if player.position.y < -100 {
            gameState = .gameOver
        }
    }

    func resetGame() {
        score = 0
        platforms.removeAll()
        coins.removeAll()
        player = Player(position: CGPoint(x: screenWidth / 2, y: 100))
        gameState = .playing
        generateInitialLevel()
    }
}
