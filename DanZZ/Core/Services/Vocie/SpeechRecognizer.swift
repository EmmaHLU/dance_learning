//
//  SpeechRecognizer.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation
import Speech
import Combine

class SpeechRecognizer: NSObject, ObservableObject {
    @Published var transcript: String = ""
    
    private let recognizer: SFSpeechRecognizer?
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest? // for stream audio recognition
    private var recognitionTask: SFSpeechRecognitionTask?
    
    init(locale: Locale) {
        self.recognizer = SFSpeechRecognizer(locale: locale)
        super.init()
        requestAuthorization()
        
    }
    
    //request authorization
    private func requestAuthorization(){
        SFSpeechRecognizer.requestAuthorization{status in
            switch status{
            case .authorized: print("Speech authorized")
            default: print("Speech not authorized")
            }
        }
    }
    //start to record
    func startRecording(){
        stopRecording()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        self.request = request
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? session.setActive(true)
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, _ )in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        
        recognitionTask = recognizer?.recognitionTask(with: request ){ result, error in
            if let result = result {
                DispatchQueue.main.async(execute: {
                    self.transcript = result.bestTranscription.formattedString
                })
            }
            if error != nil{
                self.stopRecording()
            }
            
        }
    }
    
    //stop recording
    func stopRecording(){
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        request = nil
        recognitionTask = nil
    }
}
