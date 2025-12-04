//
//  PlayerManager.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation
import AVFoundation
import Combine
import FirebaseAILogic

class PlayerManager: ObservableObject{
    
    static let shared = PlayerManager()
    @Published private(set) var player: AVPlayer?
    @Published private(set) var currentTime: Double = 0.0
    var loopObserver: Any?
    var timeObserver: Any?

    
    private init(){
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
        timeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = CMTimeGetSeconds(time)
        }
    }
    
    func setGlobalRate (_ rate: Float) -> JSONObject{
        self.player?.rate = rate
        print("the global rate is \(rate)")
        return ["result": .string("success")]
    }
    
    func seekBeatPosition(groupIndex: Int, beatsPerGroup: Int) -> JSONObject {
        let targetBeatIndex = ((groupIndex - 1) * beatsPerGroup) + 1
        print("seek to beats \(targetBeatIndex)")
        let startTime = BeatAPIService.shared.beats_to_time(beatIndex: targetBeatIndex) ??  0
        print("seek to time \(startTime)")
        return seekPosition(startTime)
    }
    
    func loopPlayBeats(startGroupIndex: Int, endGroupIndex: Int, beatsPerGroup: Int, loopTimes: Int = .max) -> JSONObject {
        let startBeatIndex = ((startGroupIndex - 1) * beatsPerGroup) + 1
        let endBeatIndex = (endGroupIndex * beatsPerGroup)
        let startTime = BeatAPIService.shared.beats_to_time(beatIndex: startBeatIndex) ?? 0
        let endTime = BeatAPIService.shared.beats_to_time(beatIndex: endBeatIndex) ?? BeatAPIService.shared.get_last_beat()!
        return loopPlay(start: startTime, end: endTime, times: loopTimes)
    }
    
    func seekPosition(_ pos: Double) -> JSONObject {
        // Validate input
        guard pos >= 0 else {
            return ["result": .string("error: position must be >= 0")]
        }
        let time = CMTime(seconds: pos, preferredTimescale: 600)
        self.player?.seek(to: time)
        self.player?.play()
        return ["result": .string("success")]
    }
    
    func loopPlay(start: Double, end: Double, times: Int = .max) -> JSONObject {
        guard let player = self.player else {
            return ["error": .string("player not initialized")]
        }
        let startTime = CMTime(seconds: start, preferredTimescale: 600)
        let endTime = CMTime(seconds: end, preferredTimescale: 600)
        player.seek(to: startTime){seekFinished in
            if seekFinished {
                player.play()
            }
        }

        var remainingLoops = times
        let interval = CMTime(seconds: 0.05, preferredTimescale: 600)
        loopObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] currentTime in
            guard let self = self else {return}
            if currentTime >= endTime {
                if remainingLoops == 1 {// finish looping
                    player.pause()
                    self.loopObserver.map{player.removeTimeObserver($0)}
                    self.loopObserver = nil
                } else { // continue to loop
                    if remainingLoops != .max {remainingLoops -= 1}
                    player.seek(to: startTime) { seekFinished in
                        if seekFinished {
                            player.play()
                        }
                    }
                }
            }
        }
        return ["result": .string("success")]
    }
}
