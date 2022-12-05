//
//  DetailGameModel.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 05/12/22.
//

import Foundation

struct DetailGameModel {
    var idGame: Int = 0
    var nameGame: String? = nil
    var releasedGame: Date? = nil
    var urlImageGame: URL? = nil
    var ratingGame: Double = 0.0
    var descriptionGame: String? = nil
    
    init(
        forId idGame:Int,
        forName nameGame:String,
        forReleasedDate releasedDate:Date,
        forUrlImage urlImage:URL,
        forRating ratingGame:Double,
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
