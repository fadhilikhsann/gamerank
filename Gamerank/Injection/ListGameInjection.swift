//
//  ListGameInjection.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import ListGame
import CoreModule
import UIKit

final class ListGameInjection {
    
    func provideUseCase<T: UseCaseDelegate>() -> T where T.Request == Any, T.Response == [ListGameModel] {
        
        let dataSource = ListGameDataSource()
        
        let repository = ListGameRepository(dataSource: dataSource)
        
        return ListGameInteractor(repository: repository) as! T
        
    }
    
}
