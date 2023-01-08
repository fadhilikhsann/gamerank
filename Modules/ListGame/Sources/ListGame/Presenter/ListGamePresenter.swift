//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import CoreModule
import RxSwift

public class ListGamePresenter<
    Interactor: UseCaseDelegate
    >: PresenterDelegate
where
Interactor.Response == [ListGameModel]
{
    
    public typealias Request = Any
    
    public typealias Response = [ListGameUIModel]
    
    
    public let useCase: Interactor
    
    public init(useCase: Interactor) {
        self.useCase = useCase
    }
    
    public func getData(request: Any?) -> Observable<[ListGameUIModel]> {
        return useCase.getData(request: nil)
            .map{
                var listGame: [ListGameUIModel] = []
                for result in $0 {
                    let game = ListGameUIModel(
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
