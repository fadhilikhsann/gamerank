//
//  ApiRepository.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation

class GameRepository: GameRepositoryProtocol {
   
    private let gameAPIProtocol: GameAPIProtocol
    private let gameCDProtocol: GameCDProtocol
    
    init(
        gameAPIProtocol: GameAPIProtocol,
        gameCDProtocol:GameCDProtocol
    ) {
        self.gameAPIProtocol = gameAPIProtocol
        self.gameCDProtocol = gameCDProtocol
    }
    
    func getListGameResponse() -> [GameEntity] {
        print("getListGameRepository")
        return gameAPIProtocol.getListGame()
    }
    
    func getDetailGameResponse(idGame: Int) -> GameEntity {
        print("getDetailGameRepository")
        return gameAPIProtocol.getDetailGame(idGame: idGame)
    }
    
    func getAllFavoriteGameResponse() -> [GameEntity] {
        print("getAllFavoriteGamesRepository")
        return gameCDProtocol.getAllFavoriteGame()
    }
    
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Bool {
        print("addFavoriteGamesRepository")
        return gameCDProtocol.addFavoriteGame(
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
        return gameCDProtocol.removeFavoriteGame(id)
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Bool {
        return gameCDProtocol.checkFavoriteGame(id)
    }
    
    func removeAllFavoriteGame(
    ) -> Bool {
        return gameCDProtocol.removeAllFavoriteGame()
    }
}
