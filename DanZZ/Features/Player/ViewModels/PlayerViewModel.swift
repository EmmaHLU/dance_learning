//
//  PlayerViewModel.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation
import AVFoundation
import Combine


class PlayerViewModel: ObservableObject {
    
    @Published var player: AVPlayer?
    @Published var videoURL: URL?
    @Published var isVideoLoaded = false
    @Published var showingFilePicker = false
    
    private let playerManager: PlayerManager
    
    init(playerManager: PlayerManager = PlayerManager()){
        self.player = nil
        self.videoURL = nil
        self.playerManager = playerManager
    }
    
    func openFilePicker() {
        self.showingFilePicker = true
    }
    
    func loadVideo (url: URL) {
        self.videoURL = url
        self.playerManager.setURL(url: url)
        
        self.player = self.playerManager.player
        
        self.isVideoLoaded = true
        self.player?.play()
    }
    
    func togglePlayPause() { self.player?.rate == 0.0 ? self.player?.play() : self.player?.pause() }
}
