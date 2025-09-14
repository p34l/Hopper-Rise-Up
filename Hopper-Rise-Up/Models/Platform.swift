//
//  Platform.swift
//  Hopper: Rise Up
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SpriteKit

class Platform {
    var position: CGPoint
    var size: CGSize
    var isActive: Bool

    init(position: CGPoint, size: CGSize = CGSize(width: 100, height: 20)) {
        self.position = position
        self.size = size
        isActive = true
    }

    func isPlayerOnPlatform(player: Player) -> Bool {
        let playerRect = CGRect(x: player.position.x - player.size.width / 2,
                                y: player.position.y - player.size.height / 2,
                                width: player.size.width,
                                height: player.size.height)

        let platformRect = CGRect(x: position.x - size.width / 2,
                                  y: position.y - size.height / 2,
                                  width: size.width,
                                  height: size.height)

        return playerRect.intersects(platformRect) && player.velocity.y <= 0
    }
}
