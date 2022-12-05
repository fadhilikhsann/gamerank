//
//  ListFavoriteGameViewModel.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 28/11/22.
//

import Foundation
import RxSwift

class ListFavoriteGameViewModel: ListFavoriteGameViewModelProtocol {
    
    private let gameUseCaseProtocol: GameUseCaseProtocol
    init(gameUseCaseProtocol: GameUseCaseProtocol) {
        self.gameUseCaseProtocol = gameUseCaseProtocol
    }
    
    func getAllFavoriteGame(
    ) -> Observable<[ListGameUIModel]> {
        
        return gameUseCaseProtocol.getAllFavoriteGame()
            .map{
                var listGame: [ListGameUIModel] = []
                for result in $0 {
                    let game = ListGameUIModel(
                        forId: result.idGame,
                        forName: result.nameGame!,
                        forReleasedDate: result.releasedGame!,
                        forUrlImage: result.urlImageGame!,
                        forRating: result.ratingGame
                    )
                    listGame.append(game)
                }
                return listGame
            }
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Observable<Bool> {
        
        return gameUseCaseProtocol.checkFavoriteGame(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }

    func removeAllFavoriteGame(
    ) -> Observable<Bool> {
        
        return gameUseCaseProtocol.removeAllFavoriteGame()
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }
    
    
}
