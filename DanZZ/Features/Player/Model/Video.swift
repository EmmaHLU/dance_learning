//
//  Video.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import Foundation

struct Video {
    let name:String
    let uploadDate: Date
    let url: String?
    let genres: [GenreDTO]
    let beats:[Double]?
    
}


struct GenreDTO: Codable {
    let id: Int
    let name: String
}
