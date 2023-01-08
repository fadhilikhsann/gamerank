//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 06/01/23.
//

import Foundation
import RxSwift
import CoreModule


public class FavoriteGamePresenter<
    RemoteUseCase: UseCaseDelegate
    >: PresenterDelegate
where
RemoteUseCase.Response == [FavoriteGameModel]
{
    
    public typealias Request = Any
    public typealias Response = [FavoriteGameUIModel]
    
    
    public var remoteUseCase: RemoteUseCase? = nil
    public var localeUseCase: FavoriteGameUseCase? = nil
    
    public init() {}
    
    public convenience init(
        remoteUseCase: RemoteUseCase,
        localeUseCase: FavoriteGameUseCase
    ) {
        self.init()
        self.remoteUseCase = remoteUseCase
        self.localeUseCase = localeUseCase
    }
    
    public func getData(request: Request?) -> Observable<[FavoriteGameUIModel]> {
        
        return remoteUseCase!.getData(request: nil)
            .map{
                var listGame: [FavoriteGameUIModel] = []
                for result in $0 {
                    let game = FavoriteGameUIModel(
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

extension FavoriteGamePresenter: FavoriteGamePresenterProtocol {
    
    public convenience init(
        localeUseCase: FavoriteGameUseCase
    ) {
        self.init()
        self.localeUseCase = localeUseCase
    }
    
    public func add(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool> {
        return localeUseCase!.add(
            idGame,
            nameGame,
            releasedGame,
            urlImageGame,
            ratingGame
        )
        .map{$0}
        .observe(on: MainScheduler.instance)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }
    
    public func removeByID(
        _ id: Int
    ) -> Observable<Bool> {
        
        return localeUseCase!.removeByID(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
    }
    
    public func checkByID(
        _ id: Int
    ) -> Observable<Bool> {
        
        return localeUseCase!.checkByID(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))

    }
}


