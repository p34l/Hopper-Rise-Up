//
//  Coin.swift
//  Hopper: Rise Up
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SpriteKit

class Coin {
    var position: CGPoint
    var size: CGSize
    var isCollected: Bool
    var value: Int

    init(position: CGPoint, value: Int = 10) {
        self.position = position
        size = CGSize(width: 20, height: 20)
        isCollected = false
        self.value = value
    }

    func isPlayerCollecting(player: Player) -> Bool {
        if isCollected { return false }

        let distance = sqrt(pow(player.position.x - position.x, 2) + pow(player.position.y - position.y, 2))
        return distance < (player.size.width + size.width) / 2
    }

    func collect() {
        isCollected = true
    }
}
