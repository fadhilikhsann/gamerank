//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import CoreModule
import RxSwift

public class DetailGamePresenter<
    Interactor: UseCaseDelegate
    >: PresenterDelegate
where
Interactor.Request == Int,
Interactor.Response == DetailGameModel
{
    
    public typealias Request = Int
    
    public typealias Response = DetailGameUIModel
    
    public let useCase: Interactor
    
    public init(useCase: Interactor) {
        self.useCase = useCase
    }
    
    public func getData(request: Int?) -> Observable<DetailGameUIModel> {
        return useCase.getData(request: request ?? 0)
            .map{
                return DetailGameUIModel(
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
