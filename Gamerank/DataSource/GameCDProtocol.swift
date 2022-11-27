//
//  CDProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 27/11/22.
//

import Foundation
import CoreData

protocol GameCDProtocol {
    var persistentContainer: NSPersistentContainer { get }
    func newTaskContext() -> NSManagedObjectContext
    func getAllFavoriteGame() -> [GameEntity]
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
