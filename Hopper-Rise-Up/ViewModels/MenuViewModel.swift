//
//  MenuViewModel.swift
//  Hopper: Rise Up
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import Foundation

class MenuViewModel: ObservableObject {
    @Published var gameState: GameState = .menu

    func startGame() {
        gameState = .playing
    }

    func goToMenu() {
        gameState = .menu
    }
}
