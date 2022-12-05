//
//  ListFavoriteGameViewModelProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 28/11/22.
//

import Foundation
import RxSwift

protocol ListFavoriteGameViewModelProtocol {
    func getAllFavoriteGame(
    ) -> Observable<[ListGameUIModel]>
    func checkFavoriteGame(
        _ id: Int
    ) -> Observable<Bool>
    func removeAllFavoriteGame(
    ) -> Observable<Bool>
}
