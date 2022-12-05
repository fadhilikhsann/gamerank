//
//  ListGameUIModel.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 05/12/22.
//

import Foundation
import UIKit

class ListGameUIModel {
    var idGame: Int = 0
    var nameGame: String? = nil
    var releasedGame: Date? = nil
    var urlImageGame: URL? = nil
    var ratingGame: Double = 0.0
    
    var imageGame: UIImage? = nil
    var state: DownloadState = .new
    
    init(
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
