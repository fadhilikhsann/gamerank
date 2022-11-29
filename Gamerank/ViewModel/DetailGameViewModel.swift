//
//  DetailGameViewModel.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 28/11/22.
//

import Foundation
import RxSwift

class DetailGameViewModel: DetailGameViewModelProtocol {
    
    lazy var detailGame = BehaviorSubject(value: GameEntity())
    lazy var addFavGame = BehaviorSubject(value: Bool())
    lazy var removeFavGame = BehaviorSubject(value: Bool())
    lazy var checkFavGame = BehaviorSubject(value: Bool())
    
    private let gameUseCaseProtocol: GameUseCaseProtocol
    init(gameUseCaseProtocol: GameUseCaseProtocol) {
        self.gameUseCaseProtocol = gameUseCaseProtocol
    }
    
    func getDetailGame(idGame: Int) -> Observable<GameEntity> {
        
        return Observable.from(optional: gameUseCaseProtocol.getDetailGame(idGame: idGame))
        
    }
    
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool> {
        
        return Observable.from(optional: gameUseCaseProtocol.addFavoriteGame(
            idGame,
            nameGame,
            releasedGame,
            urlImageGame,
            ratingGame
        )
        )
        
    }
    
    func removeFavoriteGame(
        _ id: Int
    ) -> Observable<Bool> {
        
        return Observable.from(optional: gameUseCaseProtocol.removeFavoriteGame(id))
        
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Observable<Bool> {

        return Observable.from(optional: gameUseCaseProtocol.checkFavoriteGame(id))
        
    }
    
}
