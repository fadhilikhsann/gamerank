//
//  ApiUseCase.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation
import RxSwift

protocol GameUseCaseProtocol {
    func getDetailGame(
        idGame: Int
    ) -> Observable<DetailGameModel>
    func getListGame(
    ) -> Observable<[ListGameModel]>
    func getAllFavoriteGame(
    ) -> Observable<[ListGameModel]>
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

