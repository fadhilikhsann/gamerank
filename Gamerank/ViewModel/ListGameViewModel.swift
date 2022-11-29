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

    func getListGame() -> Observable<[GameEntity]> {
        
        return Observable.from(optional: gameUseCaseProtocol.getListGame())
        
    }
    
}
