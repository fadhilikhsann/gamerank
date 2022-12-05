//
//  ApiRepository.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation
import RxSwift

class GameRepository: GameRepositoryProtocol {
   
    private let gameAPIProtocol: GameAPIProtocol
    private let gameCDProtocol: GameCDProtocol
    private var disposeBag = DisposeBag()
    
    init(
        gameAPIProtocol: GameAPIProtocol,
        gameCDProtocol:GameCDProtocol
    ) {
        self.gameAPIProtocol = gameAPIProtocol
        self.gameCDProtocol = gameCDProtocol
    }
    
    func getListGameResponse() -> Observable<[ListGameEntity]> {
        print("getListGameRepository")
        
        return gameAPIProtocol.getListGame()
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      
    }
    
    func getDetailGameResponse(idGame: Int) -> Observable<DetailGameEntity> {
        print("getDetailGameRepository")
        return gameAPIProtocol.getDetailGame(idGame: idGame)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func getAllFavoriteGameResponse() -> Observable<[ListGameEntity]> {
        print("getAllFavoriteGamesRepository")
        return gameCDProtocol.getAllFavoriteGame()
            .map{$0}
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
        print("addFavoriteGamesRepository")
        return gameCDProtocol.addFavoriteGame(
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
        return gameCDProtocol.removeFavoriteGame(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Observable<Bool> {
        return gameCDProtocol.checkFavoriteGame(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func removeAllFavoriteGame(
    ) -> Observable<Bool> {
        return gameCDProtocol.removeAllFavoriteGame()
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
