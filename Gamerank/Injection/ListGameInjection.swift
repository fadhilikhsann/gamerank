//
//  ListGameInjection.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import ListGame

final class ListGameInjection {
    
    private func provideDataSource() -> ListGameDataSourceProtocol {
        return ListGameDataSource()
    }
    
    private func provideGameRepository() -> ListGameRepositoryProtocol {
        return ListGameRepository(dataSource: provideDataSource())
    }
    
    func provideGameUseCase() -> ListGameUseCase {
        return ListGameInteractor(repository: provideGameRepository())
    }
}
