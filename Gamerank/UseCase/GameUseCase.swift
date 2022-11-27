//
//  GameUseCase.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation

class GameUseCase: GameUseCaseProtocol {
    
    private let gameRepositoryProtocol: GameRepositoryProtocol
    var detailGame: GameEntity? = nil
    var listGame: [GameEntity]? = nil
    
    init(repository: GameRepositoryProtocol) {
        self.gameRepositoryProtocol = repository
    }
    
    func getDetailGame(idGame: Int) -> GameEntity {
        print("getDetailGameUseCase")
        return gameRepositoryProtocol.getDetailGameResponse(idGame: idGame)
    }
    
    func getListGame() -> [GameEntity] {
        print("getListGameUseCase")
        return gameRepositoryProtocol.getListGameResponse()
    }
    
    func getAllFavoriteGame() -> [GameEntity] {
        print("getAllFavoriteGameUseCase")
        return gameRepositoryProtocol.getAllFavoriteGameResponse()
    }
    
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Bool {
        return gameRepositoryProtocol.addFavoriteGame(
            idGame,
            nameGame,
            releasedGame,
            urlImageGame,
            ratingGame
        )
    }
    
    func removeFavoriteGame(
        _ id: Int
    ) -> Bool {
        return gameRepositoryProtocol.removeFavoriteGame(id)
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Bool {
        return gameRepositoryProtocol.checkFavoriteGame(id)
    }
    
    func removeAllFavoriteGame(
    ) -> Bool {
        return gameRepositoryProtocol.removeAllFavoriteGame()
    }
    
}
