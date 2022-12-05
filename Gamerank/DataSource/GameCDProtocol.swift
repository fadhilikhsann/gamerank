//
//  CDProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 27/11/22.
//

import Foundation
import CoreData
import RxSwift

protocol GameCDProtocol {
    var persistentContainer: NSPersistentContainer { get }
    func newTaskContext() -> NSManagedObjectContext
    func getAllFavoriteGame() -> Observable<[ListGameEntity]>
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool>
    func removeFavoriteGame(
        _ id: Int
    ) -> Observable<Bool>
    func checkFavoriteGame(
        _ id: Int
    ) -> Observable<Bool>
    func removeAllFavoriteGame(
    ) -> Observable<Bool>
}
