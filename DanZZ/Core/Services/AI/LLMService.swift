//
//  LLMService.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation
import FirebaseAILogic

class GeminiAIService {
//    static let shared = GeminiAIService()
   
    let systemPrompt = """
        You are the instruction interpreter for a voice-controlled intelligent music player.  
        You must strictly follow these rules:

        1. If the user's request requires multiple actions, you MUST call the necessary functions in sequence until the task is fully completed.

        2. You are allowed to make multiple function calls in response to a single user instruction (multi-step / multi-function calling).

        3. Do NOT answer with natural language unless the request cannot be fulfilled using the available functions.

        4. Extract parameters such as playback speed, beat group number, or loop ranges directly from the user's natural-language request.

        5. For example, for a command like  
           “Play the first 8-beat group at 0.5x speed”,  
           you MUST:
           - first call `setGlobalRate(new_rate)`
           - then call `seekBeatPosition(groupIndex, beatsPerGroup)`

        Examples:

        - “Set the speed to 1.2x” → call `setGlobalRate`
        - “Play the 3rd 8-beat group” → call `seekBeatPosition`
        - “Play the 1st 8-beat group at 0.5 speed” →  
           1) call `setGlobalRate(0.5)`  
           2) call `seekBeatPosition(1, beatsPerGroup)`
        - “Loop from group 2 to group 4 two times” → call `loopPlayBeats`

        """
        
    let playerManager = PlayerManager.shared
    var model: GenerativeModel
    var chat: Chat
    
    init() {
        self.model = FirebaseAI.firebaseAI(backend: .googleAI())
            .generativeModel(modelName: "gemini-2.5-flash",
                             tools: [.functionDeclarations([ToolRegistry.setRateTool,
                                                            ToolRegistry.seekBeatPosition,
                                                            ToolRegistry.playBeats,
                                                            ToolRegistry.loopPlayBeats])],
                             systemInstruction: ModelContent(role: "system", parts: [TextPart(systemPrompt)]),
            )
        self.chat = model.startChat()
    }
  
    public func callAIService(instruction: String) async{
       
        let response: GenerateContentResponse
        do{
            response = try await chat.sendMessage(instruction)
        } catch{
            return
        }
        
        var functionResponses = [FunctionResponsePart]()
        
        for functionCall in response.functionCalls{
            print(response.functionCalls)
            print("function call \(functionCall.name)")
            
            if functionCall.name == "setGlobalRate"{
                guard case let .number(rate) = functionCall.args["new_rate"] else { fatalError()}
                functionResponses.append(FunctionResponsePart(name: functionCall.name, response: playerManager.setGlobalRate(Float(rate))))
            }
            if functionCall.name == "seekBeatPosition" {
                //for the moment, JSONValue doesn't support integer directly. so even if the parameter is defined as integer
                //for example, "groupIndex" : .integer(description: "The index of the beat group starting from 1."),
                //has to decode it as .number which is Double and then covert to Int explictly
                guard case let .number(groupIndex) = functionCall.args["groupIndex"] else { fatalError()}
                guard case let .number(beatsPerGroup) = functionCall.args["beatsPerGroup"] else { fatalError()}
                functionResponses.append(FunctionResponsePart(name: functionCall.name, response: playerManager.seekBeatPosition(groupIndex: Int(groupIndex), beatsPerGroup: Int(beatsPerGroup))))
            }
            if functionCall.name == "playBeats" {
                guard case let .number(startGroupIndex) = functionCall.args["startGroupIndex"] else { fatalError()}
                guard case let .number(endGroupIndex) = functionCall.args["endGroupIndex"] else { fatalError()}
                guard case let .number(beatsPerGroup) = functionCall.args["beatsPerGroup"] else { fatalError()}
                functionResponses.append(FunctionResponsePart(name: functionCall.name, response: playerManager.playBeats(startGroupIndex: Int(startGroupIndex), endGroupIndex: Int(endGroupIndex), beatsPerGroup: Int(beatsPerGroup))))
            }
            if functionCall.name == "loopPlayBeats" {
                guard case let .number(startGroupIndex) = functionCall.args["startGroupIndex"] else { fatalError()}
                guard case let .number(endGroupIndex) = functionCall.args["endGroupIndex"] else { fatalError()}
                guard case let .number(beatsPerGroup) = functionCall.args["beatsPerGroup"] else { fatalError()}
                guard case let .number(loopTimes) = functionCall.args["loopTimes"] else { fatalError()}
                functionResponses.append(FunctionResponsePart(name: functionCall.name, response: playerManager.loopPlayBeats(startGroupIndex: Int(startGroupIndex), endGroupIndex: Int(endGroupIndex), beatsPerGroup: Int(beatsPerGroup), loopTimes: Int(loopTimes))))
            }
        }
//        playerManager.play()
    }
}
