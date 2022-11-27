//
//  ApiPresenter.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation

class GamePresenter: GamePresenterProtocol {
    
    private let gameUseCaseProtocol: GameUseCaseProtocol
    
    init(gameUseCaseProtocol: GameUseCaseProtocol) {
        self.gameUseCaseProtocol = gameUseCaseProtocol
    }
    
    func getListGame() -> [GameEntity] {
        print("getListGamePresenter")
        return gameUseCaseProtocol.getListGame()
    }
    
    func getDetailGame(idGame: Int) -> GameEntity {
        print("getDetailGamePresenter")
        return gameUseCaseProtocol.getDetailGame(idGame: idGame)
    }
    
    func getAllFavoriteGame() -> [GameEntity] {
        print("getAllFavoriteGamePresenter")
        return gameUseCaseProtocol.getAllFavoriteGame()
    }
    
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Bool {
        return gameUseCaseProtocol.addFavoriteGame(
            idGame,
            nameGame,
            releasedGame,
            urlImageGame,
            ratingGame)
    }
    
    func removeFavoriteGame(
        _ id: Int
    ) -> Bool {
        return gameUseCaseProtocol.removeFavoriteGame(id)
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Bool {
        return gameUseCaseProtocol.checkFavoriteGame(id)
    }
    
    func removeAllFavoriteGame(
    ) -> Bool {
        return gameUseCaseProtocol.removeAllFavoriteGame()
    }
    
}
