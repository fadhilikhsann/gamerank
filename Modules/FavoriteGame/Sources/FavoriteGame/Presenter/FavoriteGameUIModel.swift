//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 06/01/23.
//

import Foundation

public class FavoriteGameUIModel {
    public var idGame: Int = 0
    public var nameGame: String? = nil
    public var releasedGame: Date? = nil
    public var urlImageGame: URL? = nil
    public var ratingGame: Double = 0.0
    
    public init(
        forId idGame:Int,
        forName nameGame:String,
        forReleasedDate releasedDate:Date,
        forUrlImage urlImage:URL,
        forRating ratingGame:Double
    ){
        self.idGame = idGame
        self.nameGame = nameGame
        self.releasedGame = releasedDate
        self.urlImageGame = urlImage
        self.ratingGame = ratingGame
    }
}
