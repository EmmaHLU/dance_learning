//
//  ToolRegistry.swift
//  DanZZ
//
//  Created by Hong Lu on 29/11/2025.
//

import Foundation
import FirebaseAILogic

enum ToolRegistry {
    
    static let setRateTool: FunctionDeclaration = FunctionDeclaration(
        name: "setGlobalRate",
        description: "Set the global playing speed for the whole video. ",
        parameters: ["new_rate" : .float(description: "The new playing speed to be set.")],
    )
    
    static let seekBeatPosition: FunctionDeclaration = FunctionDeclaration(
        name: "seekBeatPosition",
        description: "Set the staring point of the player based on beats",
        parameters: ["groupIndex" : .integer(description: "The index of the beat group starting from 1."),
                     "beatsPerGroup": .integer(description: "The number of beats per group.")]
    )
    
    static let playBeats: FunctionDeclaration = FunctionDeclaration (
        name: "loopPlayBeats",
        description: "Play the selected beats in a loop mode.",
        parameters: ["startGroupIndex" : .integer(description: "The index of the starting beat group starting from 1. "),
                     "endGroupIndex": .integer(description: "The index of the ending beat group starting from 1. "),
                     "beatsPerGroup": .integer(description: "The number of beats per group."),]
    )
    
    
    static let loopPlayBeats: FunctionDeclaration = FunctionDeclaration (
        name: "loopPlayBeats",
        description: "Play the selected beats in a loop mode.",
        parameters: ["startGroupIndex" : .integer(description: "The index of the starting beat group starting from 1. "),
                     "endGroupIndex": .integer(description: "The index of the ending beat group starting from 1. "),
                     "beatsPerGroup": .integer(description: "The number of beats per group."),
                     "loopTimes": .integer(description: "The number of looping times to play. Set to infinity if the user doesn't mention.")]
    )
}
