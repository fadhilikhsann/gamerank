//
//  GameUseCase.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation
import RxSwift

class GameUseCase: GameUseCaseProtocol {
    
    private let gameRepositoryProtocol: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.gameRepositoryProtocol = repository
    }
    
    func getDetailGame(idGame: Int) -> Observable<DetailGameModel> {
        print("getDetailGameUseCase")
        
        return gameRepositoryProtocol.getDetailGameResponse(idGame: idGame)
            .map{
                return DetailGameModel(
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
    
    func getListGame() -> Observable<[ListGameModel]> {
        print("getListGameUseCase")
        
        return gameRepositoryProtocol.getListGameResponse()
            .map{
                var listGame: [ListGameModel] = []
                for result in $0 {
                    let game = ListGameModel(
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
    
    func getAllFavoriteGame() -> Observable<[ListGameModel]> {
        print("getAllFavoriteGameUseCase")
        
        return gameRepositoryProtocol.getAllFavoriteGameResponse()
            .map{
                var listGame: [ListGameModel] = []
                for result in $0 {
                    let game = ListGameModel(
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
    
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool> {
        return gameRepositoryProtocol.addFavoriteGame(
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
        return gameRepositoryProtocol.removeFavoriteGame(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Observable<Bool> {
        return gameRepositoryProtocol.checkFavoriteGame(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func removeAllFavoriteGame(
    ) -> Observable<Bool> {
        return gameRepositoryProtocol.removeAllFavoriteGame()
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}
