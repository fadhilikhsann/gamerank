//
//  FavoriteGameInjection.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 07/01/23.
//

import Foundation
import FavoriteGame
import CoreModule

final class FavoriteGameInjection {
    
    func provideDataSource<T: DataSourceDelegate>() -> T {
        return FavoriteGameDataSource() as! T
    }
    func provideLocaleDataSource() -> FavoriteGameDataSourceProtocol {
        return FavoriteGameDataSource()
    }
    
    func provideRemoteRepository<T: RepositoryDelegate>() -> T {
        let repository: FavoriteGameRepository<
                FavoriteGameDataSource
            > = FavoriteGameRepository(
            remoteDataSource: provideDataSource()
        )
        return repository as! T
    }
    func provideLocaleRepository() -> FavoriteGameRepositoryProtocol {
        let repository: FavoriteGameRepository<
                FavoriteGameDataSource
            > = FavoriteGameRepository(
            localeDataSource: provideLocaleDataSource()
        )
        return repository
    }
    
    func provideLocaleUseCase() -> FavoriteGameUseCase {
        
        let interactor: FavoriteGameInteractor<
            FavoriteGameRepository<
                FavoriteGameDataSource
            >
        > = FavoriteGameInteractor(
            localeRepository: provideLocaleRepository()
        )
        
        return interactor
        
    }
    
    func provideRemoteUseCase<T: UseCaseDelegate>() -> T where T.Request == Any, T.Response == [FavoriteGameModel] {
        
        let interactor: FavoriteGameInteractor<
            FavoriteGameRepository<
                FavoriteGameDataSource
            >
        > = FavoriteGameInteractor(
            remoteRepository: provideRemoteRepository()
        )
        
        return interactor as! T
        
    }
}
