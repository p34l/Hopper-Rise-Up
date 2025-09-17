//
//  SoundManager.swift
//  Hopper-Rise-Up
//
//  Created by Misha Kandaurov on 16.09.2025.
//

import AVFoundation

class SoundManager: NSObject {
    static let shared = SoundManager()

    private var bgPlayer: AVAudioPlayer?
    private var sfxPlayers: [AVAudioPlayer] = []

    override private init() {
        super.init()
    }
    
    func stopBackground() {
        bgPlayer?.stop()
    }

    func playBackgroundLoop(name: String, fileType: String = "wav") {
        stopBackground()
        
        if let path = Bundle.main.path(forResource: name, ofType: fileType) {
            let url = URL(fileURLWithPath: path)
            do {
                bgPlayer = try AVAudioPlayer(contentsOf: url)
                bgPlayer?.numberOfLoops = -1
                bgPlayer?.prepareToPlay()
                bgPlayer?.play()
            } catch {
                print("Error playing background music: \(error)")
            }
        }
    }

    func playEffect(name: String, fileType: String = "wav") {
        if let path = Bundle.main.path(forResource: name, ofType: fileType) {
            let url = URL(fileURLWithPath: path)
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                sfxPlayers.append(player)
                player.delegate = self
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
            } catch {
                print("Error playing sound effect: \(error)")
            }
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = sfxPlayers.firstIndex(of: player) {
            sfxPlayers.remove(at: index)
        }
    }
}
