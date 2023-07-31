//
//  CustomPlayer.swift
//  GalleryEf
//
//  Created by user on 29.07.2023.
//

import UIKit
import AVFoundation

class CustomPlayer: NSObject {
    
    private var player: AVPlayer?
    
    init(playerView: UIView, videoUrl: URL) {
        super.init()
        
        createPlayer(playerView: playerView, videoUrl: videoUrl)
        play()
    }
    
    private func createPlayer(playerView: UIView, videoUrl: URL) {
        let asset = AVAsset(url: videoUrl)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer)
    }
    
    private func play() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.player?.play()
        }
    }
}
