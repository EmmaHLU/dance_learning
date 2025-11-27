//
//  PlayerManager.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation
import AVFoundation
import Combine

class PlayerManager: ObservableObject{
    
    @Published private(set) var player: AVPlayer?
    @Published private(set) var currentTime: Double = 0.0
    
    init(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.allowBluetoothHFP, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print ("error")
        }
        self.player = AVPlayer()
    }
    func setURL (url: URL) {
        let asset = AVURLAsset(url: url)
        self.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = CMTimeGetSeconds(time)
        }
    }
    
    func setGlobalRate (_ rate: Float){
        self.player?.rate = rate
        print("the global rate is \(rate)")
    }
}
