//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import CoreModule
import RxSwift

public struct ListGameInteractor<
    Repository: RepositoryDelegate
>: UseCaseDelegate
where
Repository.Response == [ListGameEntity]
{
    
    public typealias Request = Any
    
    public typealias Response = [ListGameModel]
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func getData(request: Any?) -> Observable<[ListGameModel]> {
        return repository.getData(request: nil)
            .map{
                var listGame: [ListGameModel] = []
                for result in $0 {
                    let game = ListGameModel(
                        forId: result.idGame,
                        forName: result.nameGame!,
                        forReleasedDate: result.releasedGame!,
                        forUrlImage: result.urlImageGame!,
                        forRating: result.ratingGame
                    )
                    listGame.append(game)
                }
                return listGame
            }
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }

}
