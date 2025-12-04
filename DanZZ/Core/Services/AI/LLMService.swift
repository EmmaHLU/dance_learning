//
//  LLMService.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation
import FirebaseAILogic

class GeminiAIService {
    static let shared = GeminiAIService()
    let model = FirebaseAI.firebaseAI(backend: .googleAI())
        .generativeModel(modelName: "gemini-2.5-flash",
                         tools: [.functionDeclarations([ToolRegistry.setRateTool,
                                                        ToolRegistry.seekBeatPosition,
                                                        ToolRegistry.loopPlayBeats])])
    
    let playerManager = PlayerManager.shared
  
    public func callAIService(instruction: String) async{
        let chat = model.startChat()
        let response: GenerateContentResponse
        do{
            response = try await chat.sendMessage(instruction)
        } catch{
            return
        }
        
        var functionResponses = [FunctionResponsePart]()
        
        for functionCall in response.functionCalls{
            if functionCall.name == "setGlobalRate"{
                guard case let .number(rate) = functionCall.args["new_rate"] else { fatalError()}
                functionResponses.append(FunctionResponsePart(name: functionCall.name, response: playerManager.setGlobalRate(Float(rate))))
            }
            if functionCall.name == "seekBeatPosition" {
                guard case let .number(groupIndex) = functionCall.args["groupIndex"] else { fatalError()}
                guard case let .number(beatsPerGroup) = functionCall.args["beatsPerGroup"] else { fatalError()}
                functionResponses.append(FunctionResponsePart(name: functionCall.name, response: playerManager.seekBeatPosition(groupIndex: Int(groupIndex), beatsPerGroup: Int(beatsPerGroup))))
            }
            if functionCall.name == "loopPlayBeats" {
                guard case let .number(startGroupIndex) = functionCall.args["startGroupIndex"] else { fatalError()}
                guard case let .number(endGroupIndex) = functionCall.args["endGroupIndex"] else { fatalError()}
                guard case let .number(beatsPerGroup) = functionCall.args["beatsPerGroup"] else { fatalError()}
                guard case let .number(loopTimes) = functionCall.args["loopTimes"] else { fatalError()}
                functionResponses.append(FunctionResponsePart(name: functionCall.name, response: playerManager.loopPlayBeats(startGroupIndex: Int(startGroupIndex), endGroupIndex: Int(endGroupIndex), beatsPerGroup: Int(beatsPerGroup), loopTimes: Int(loopTimes))))
            }
        }
    }
}
