//
//  DetailGameViewModelProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 28/11/22.
//

import Foundation
import RxSwift

protocol DetailGameViewModelProtocol {
    func getDetailGame(
        idGame: Int
    ) -> Observable<GameEntity>
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
}
