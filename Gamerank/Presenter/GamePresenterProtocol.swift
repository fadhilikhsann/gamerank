//
//  ApiPresenterProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation

protocol GamePresenterProtocol {
    func getListGame(
    ) -> [GameEntity]
    func getDetailGame(
        idGame: Int
    ) -> GameEntity
    func getAllFavoriteGame(
    ) -> [GameEntity]
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Bool
    func removeFavoriteGame(
        _ id: Int
    ) -> Bool
    func checkFavoriteGame(
        _ id: Int
    ) -> Bool
    func removeAllFavoriteGame(
    ) -> Bool
}
