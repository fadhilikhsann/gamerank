//
//  DetailGameInjection.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import DetailGame

final class DetailGameInjection {
    
    private func provideDataSource() -> DetailGameDataSourceProtocol {
        return DetailGameDataSource()
    }
    
    private func provideGameRepository() -> DetailGameRepositoryProtocol {
        return DetailGameRepository(dataSource: provideDataSource())
    }
    
    func provideGameUseCase() -> DetailGameUseCase {
        return DetailGameInteractor(repository: provideGameRepository())
    }
}
