//
//  DetailGameViewModel.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 28/11/22.
//

import Foundation
import RxSwift

class DetailGameViewModel: DetailGameViewModelProtocol {
    
    private let gameUseCaseProtocol: GameUseCaseProtocol
    init(gameUseCaseProtocol: GameUseCaseProtocol) {
        self.gameUseCaseProtocol = gameUseCaseProtocol
    }
    
    func getDetailGame(idGame: Int) -> Observable<DetailGameUIModel> {
        
        return gameUseCaseProtocol.getDetailGame(idGame: idGame)
            .map{
                return DetailGameUIModel(
                    forId: $0.idGame,
                    forName: $0.nameGame!,
                    forReleasedDate: $0.releasedGame!,
                    forUrlImage: $0.urlImageGame!,
                    forRating: $0.ratingGame,
                    forDescription: $0.descriptionGame!
                )
            }
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }
    
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool> {
        
        return gameUseCaseProtocol.addFavoriteGame(
            idGame,
            nameGame,
            releasedGame,
            urlImageGame,
            ratingGame
        )
        .map{$0}
        .observe(on: MainScheduler.instance)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
        
    }
    
    func removeFavoriteGame(
        _ id: Int
    ) -> Observable<Bool> {
        
        return gameUseCaseProtocol.removeFavoriteGame(id)
            .map{$0}
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
    
}
