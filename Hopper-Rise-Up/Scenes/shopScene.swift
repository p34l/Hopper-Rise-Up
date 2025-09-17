//
//  shopScene.swift
//  Hopper-Rise-Up
//
//  Created by Misha Kandaurov on 16.09.2025.
//

//
//  ShopScene.swift
//  Hopper: Rise Up
//
//  Created by Misha Kandaurov on 16.09.2025.
//

import SpriteKit

class ShopScene: SKScene {
    private var coinsLabel: SKLabelNode!
    private var backButton: SKLabelNode!

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        setupCoinsLabel()
        setupBackButton()
        setupShopItems()
    }

    private func setupCoinsLabel() {
        coinsLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        let totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        coinsLabel.text = "Coins: \(totalCoins)"
        coinsLabel.fontSize = 28
        coinsLabel.fontColor = .yellow
        coinsLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        addChild(coinsLabel)
    }

    private func setupBackButton() {
        backButton = SKLabelNode(fontNamed: "Arial-BoldMT")
        backButton.text = "Back"
        backButton.fontSize = 34
        backButton.fontColor = .white
        backButton.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        backButton.name = "backButton"
        addChild(backButton)
    }

    private func setupShopItems() {
        let item1 = SKLabelNode(fontNamed: "Arial-BoldMT")
        item1.text = "Item 1 - 50 coins"
        item1.fontSize = 30
        item1.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        item1.name = "item1"
        addChild(item1)

        let item2 = SKLabelNode(fontNamed: "Arial-BoldMT")
        item2.text = "Item 2 - 100 coins"
        item2.fontSize = 30
        item2.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        item2.name = "item2"
        addChild(item2)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)

        for node in nodes {
            if node.name == "backButton" {
                let menuScene = MenuScene(size: size, menuViewModel: MenuViewModel())
                let transition = SKTransition.fade(withDuration: 0.5)
                view?.presentScene(menuScene, transition: transition)
            } else if node.name == "item1" {
                buyItem(cost: 50)
            } else if node.name == "item2" {
                buyItem(cost: 100)
            }
        }
    }

    private func buyItem(cost: Int) {
        var totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        if totalCoins >= cost {
            totalCoins -= cost
            UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
            coinsLabel.text = "Coins: \(totalCoins)"
            print("Item bought for \(cost) coins!")
        } else {
            print("Not enough coins!")
        }
    }
}
