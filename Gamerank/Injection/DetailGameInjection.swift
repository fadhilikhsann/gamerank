//
//  DetailGameInjection.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import DetailGame
import CoreModule

final class DetailGameInjection {
    
    func provideUseCase<T: UseCaseDelegate>() -> T where T.Request == Int, T.Response == DetailGameModel {
        
        let dataSource = DetailGameDataSource()
        
        let repository = DetailGameRepository(dataSource: dataSource)
        
        return DetailGameInteractor(repository: repository) as! T
        
    }
}
