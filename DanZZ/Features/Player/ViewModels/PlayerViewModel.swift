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
    private let aiService = GeminiAIService()
    
    //speech recognition
    @Published var transcript: String = ""
    @Published var isRecording = false
    let speech: SpeechRecognizer
    
    
    
    init(locale: Locale, playerManager: PlayerManager = PlayerManager.shared){
        self.player = nil
        self.videoURL = nil
        self.playerManager = playerManager
        self.speech = SpeechRecognizer(locale: locale)
    }
    
    func openFilePicker() {
        self.showingFilePicker = true
    }
    
    func loadVideo (url: URL) async {
        self.videoURL = url
        await self.playerManager.setURL(url: url)
        
        self.player = self.playerManager.player
        
        self.isVideoLoaded = true
        self.player?.play()
    }
    
    func togglePlayPause() { self.player?.rate == 0.0 ? self.player?.play() : self.player?.pause() }
    
    func callAI(instruction: String) async {
       await aiService.callAIService(instruction: instruction)
    }
    
    //speech recognition
    func startSpeech(){
        transcript = ""
        speech.startRecording()
        isRecording = true
        
        speech.$transcript.receive(on: DispatchQueue.main)
            .assign(to: &$transcript)
    }
    
    func stopSpeech(){
        guard isRecording else { return }
        speech.stopRecording()
        isRecording = false
        Task{
            print("the transcript is: ")
            print(transcript)
            await callAI(instruction: transcript)
        }
    }
    
    //extract beats
    func extractBeats (url: URL) {
        BeatAPIService.shared.extractBeats(url: url){beats, error in
            if let beats = beats {
                print("beats:\(beats)")
            } else if let error = error {
                print("error")
            }}
    }
}
