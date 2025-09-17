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
    var hasCameraMovedUp: Bool = false

    var player: Player
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
        player.bounce()
    }

    func getPlayerPosition() -> CGPoint {
        return player.position
    }

    func movePlayerLeft() {
        player.moveLeft()
    }

    func movePlayerRight() {
        player.moveRight()
    }

    func stopPlayer() {
        player.stopMoving()
    }

    private func checkPlatformCollisions() {
        for platform in platforms {
            let playerBottomPrevious = player.position.y - player.size.height / 2 - player.velocity.y * (1.0 / 60.0)
            let playerBottomCurrent = player.position.y - player.size.height / 2

            let platformTop = platform.position.y + platform.size.height / 2

            if playerBottomPrevious >= platformTop && playerBottomCurrent <= platformTop {
                let playerLeft = player.position.x - player.size.width / 2
                let playerRight = player.position.x + player.size.width / 2
                let platformLeft = platform.position.x - platform.size.width / 2
                let platformRight = platform.position.x + platform.size.width / 2

                if playerRight >= platformLeft && playerLeft <= platformRight {
                    player.position.y = platformTop + player.size.height / 2
                    player.bounce()
                    break
                }
            }
        }
    }

    private func checkCoinCollection() {
        for (index, coin) in coins.enumerated().reversed() {
            if !coin.isCollected && coin.isPlayerCollecting(player: player) {
                coin.collect()
                SoundManager.shared.playEffect(name: "coin-collect")
                score += coin.value
                coins.remove(at: index)
            }
        }
    }

    private func generateInitialLevel() {
        let jumpHeight: CGFloat = 100
        let startY: CGFloat = 50

        for i in 0 ..< 5 {
            let x = CGFloat.random(in: 50 ... (screenWidth - 50))
            let y = startY + CGFloat(i) * jumpHeight
            let platform = Platform(position: CGPoint(x: x, y: y))
            platforms.append(platform)
        }

        for i in 0 ..< 3 {
            let x = CGFloat.random(in: 50 ... (screenWidth - 50))
            let y = startY + CGFloat(i) * jumpHeight + 50
            let coin = Coin(position: CGPoint(x: x, y: y))
            coins.append(coin)
        }
    }

    private func generateNewElements() {
        if platforms.isEmpty || (platforms.last!.position.y < screenHeight + 200) {
            let x = CGFloat.random(in: 50 ... (screenWidth - 50))
            let y = (platforms.last?.position.y ?? 0) + 100
            let platform = Platform(position: CGPoint(x: x, y: y))
            platforms.append(platform)
        }

        let currentCoinsCount = coins.count
        while currentCoinsCount + 0 < 5 && coins.count < 5 {
            let x = CGFloat.random(in: 50 ... (screenWidth - 50))
            let baseY = platforms.last?.position.y ?? (player.position.y + screenHeight / 2)
            let y = baseY + CGFloat.random(in: 40 ... 100)
            let coin = Coin(position: CGPoint(x: x, y: y))
            coins.append(coin)
        }
    }

    func saveCollectedCoins() {
        let currentCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        let newTotal = currentCoins + score
        UserDefaults.standard.set(newTotal, forKey: "totalCoins")
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
