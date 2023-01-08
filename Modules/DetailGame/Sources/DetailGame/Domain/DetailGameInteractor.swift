//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import CoreModule
import RxSwift

public struct DetailGameInteractor<
    Repository: RepositoryDelegate
>: UseCaseDelegate
where
Repository.Request == Int,
Repository.Response == DetailGameEntity
{
    
    public typealias Request = Int
    
    public typealias Response = DetailGameModel
    
    private let repository: Repository
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func getData(request: Int?) -> Observable<DetailGameModel> {
        return repository.getData(request: request ?? 0)
            .map{
                return DetailGameModel(
                    forId: $0.idGame,
                    forName: $0.nameGame!,
                    forReleasedDate: $0.releasedGame!,
                    forUrlImage: $0.urlImageGame!,
                    forRating: $0.ratingGame,
                    forDescription: $0.descriptionGame!
                )
            }
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }

}
