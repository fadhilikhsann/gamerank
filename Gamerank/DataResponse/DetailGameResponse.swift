//
//  ApiGameEntity.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation

struct DetailGameResponse: Codable {
    var idGame: Int = 0
    var nameGame: String? = nil
    var releasedGame: Date? = nil
    var urlImageGame: URL? = nil
    var ratingGame: Double = 0.0
    var descriptionGame: String? = nil
    var metacriticGame: Int = 0
    
    
    enum CodingKeys: String, CodingKey{
        
        case idGame = "id"
        case nameGame = "name"
        case releasedGame = "released"
        case urlImageGame = "background_image"
        case ratingGame = "rating"
        case descriptionGame = "description"
        case metacriticGame = "metacritic"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        idGame = try container.decodeIfPresent(Int.self, forKey: .idGame) ?? 0
        
        nameGame = try container.decodeIfPresent(String.self, forKey: .nameGame)
        
        let dateString = try container.decodeIfPresent(String.self, forKey: .releasedGame)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString ?? "")
        releasedGame = date
        
        urlImageGame = try container.decodeIfPresent(URL.self, forKey: .urlImageGame)
        ratingGame = try container.decodeIfPresent(Double.self, forKey: .ratingGame) ?? 0.0
        if let descriptionGame = try? container.decode(String.self, forKey: .descriptionGame) {
            self.descriptionGame = descriptionGame
        }
        if let metacriticGame = try? container.decode(Int.self, forKey: .metacriticGame) {
            self.metacriticGame = metacriticGame
        }
    }
    
    init(
        forId idGame: Int,
        forName nameGame: String,
        forReleasedDate releasedDate: Date,
        forUrlImage urlImage: URL,
        forRating ratingGame: Double,
        forDescription descriptionGame: String
    ){
        self.idGame = idGame
        self.nameGame = nameGame
        self.releasedGame = releasedDate
        self.urlImageGame = urlImage
        self.ratingGame = ratingGame
        self.descriptionGame = descriptionGame
    }
}
