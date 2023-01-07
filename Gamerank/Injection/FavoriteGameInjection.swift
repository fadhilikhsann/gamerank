//
//  FavoriteGameInjection.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 07/01/23.
//

import Foundation
import FavoriteGame

final class FavoriteGameInjection {
    
    private func provideDataSource() -> FavoriteGameDataSourceProtocol {
        return FavoriteGameDataSource()
    }
    
    private func provideGameRepository() -> FavoriteGameRepositoryProtocol {
        return FavoriteGameRepository(dataSource: provideDataSource())
    }
    
    func provideGameUseCase() -> FavoriteGameUseCase {
        return FavoriteGameInteractor(repository: provideGameRepository())
    }
}
