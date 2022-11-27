//
//  ApiInjection.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation

final class GameInjection {
    
    private func provideGameCD() -> GameCDProtocol {
        print("ProvideGameDataSource")
        return GameDataSource()
    }
    
    private func provideGameAPI() -> GameAPIProtocol {
        print("ProvideGameDataSource")
        return GameDataSource()
    }
    
    private func provideGameRepository() -> GameRepositoryProtocol {
        print("ProvideGameRepository")
        return GameRepository(
            gameAPIProtocol: provideGameAPI(),
            gameCDProtocol: provideGameCD()
        )
    }
    
    func provideGameUseCase() -> GameUseCaseProtocol {
        print("ProvideGameUseCase")
        return GameUseCase(repository: provideGameRepository())
    }
}
