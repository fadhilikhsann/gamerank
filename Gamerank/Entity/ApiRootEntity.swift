//
//  ApiEntity.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation

struct ApiRootEntity:Codable{
    var count: Int = 0
    var next: String? = nil
    var previous: String? = nil
    var listGame: [GameEntity]? = nil
    
    enum CodingKeys: String, CodingKey{
        case count = "count"
        case next = "next"
        case previous = "previous"
        case listGame = "results"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
        next = try container.decodeIfPresent(String.self, forKey: .next)
        previous = try container.decodeIfPresent(String.self, forKey: .previous)
        listGame = try container.decode([GameEntity].self, forKey: .listGame)
    }
}
