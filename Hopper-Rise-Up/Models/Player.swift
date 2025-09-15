//
//  Player.swift
//  Hopper: Rise Up
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import SpriteKit

class Player {
    var position: CGPoint
    var velocity: CGPoint
    var isJumping: Bool
    var size: CGSize

    init(position: CGPoint = CGPoint(x: 0, y: 0)) {
        self.position = position
        velocity = CGPoint(x: 0, y: 0)
        isJumping = false
        size = CGSize(width: 40, height: 40)
    }

    func update(deltaTime: TimeInterval) {
        velocity.y -= 500 * deltaTime

        position.x += velocity.x * deltaTime
        position.y += velocity.y * deltaTime

        let halfWidth = size.width / 2
        if position.x < halfWidth {
            position.x = halfWidth
            velocity.x = 0
        }
        if position.x > UIScreen.main.bounds.width - halfWidth {
            position.x = UIScreen.main.bounds.width - halfWidth
            velocity.x = 0
        }

        if position.y <= 0 {
            position.y = 0
            bounce()
        }
    }

    func bounce() {
        velocity.y = 400
    }

    func moveLeft() {
        velocity.x = -200
    }

    func moveRight() {
        velocity.x = 200
    }

    func stopMoving() {
        velocity.x = 0
    }
}
