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
    ) -> Observable<[GameEntity]> {
        
        return Observable.from(optional: gameUseCaseProtocol.getAllFavoriteGame())
        
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Observable<Bool> {
        
        return Observable.from(optional: gameUseCaseProtocol.checkFavoriteGame(id))
        
    }

    func removeAllFavoriteGame(
    ) -> Observable<Bool> {
        
        return Observable.from(optional: gameUseCaseProtocol.removeAllFavoriteGame())
        
    }
    
    
}
