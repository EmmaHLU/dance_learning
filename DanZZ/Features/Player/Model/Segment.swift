//
//  Segment.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation

struct BeatSegment {
    let id: Int
    let start: Int
    let end: Int
}


struct VideoSegment {
    let id = UUID()
    let start: Double
    let end: Double
    var rate: Float
    var label: String
}
