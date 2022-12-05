//
//  ApiRepositoryProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation
import RxSwift

protocol GameRepositoryProtocol {
    func getListGameResponse(
    ) -> Observable<[ListGameEntity]>
    func getDetailGameResponse(
        idGame: Int
    ) -> Observable<DetailGameEntity>
    func getAllFavoriteGameResponse(
    ) -> Observable<[ListGameEntity]>
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
