//
//  ApiPresenter.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation
import RxSwift

class ListGameViewModel: ListGameViewModelProtocol {
    
    private let gameUseCaseProtocol: GameUseCaseProtocol
    init(gameUseCaseProtocol: GameUseCaseProtocol) {
        self.gameUseCaseProtocol = gameUseCaseProtocol
    }
    
    func getListGame() -> Observable<[ListGameUIModel]> {
        
        return gameUseCaseProtocol.getListGame()
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
    
}
