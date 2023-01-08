//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 06/01/23.
//

import Foundation
import RxSwift
import CoreModule

public struct FavoriteGameInteractor<
    RemoteRepository: RepositoryDelegate
>: UseCaseDelegate
where
RemoteRepository.Response == [FavoriteGameEntity]
{

    public typealias Request = Any
    
    public typealias Response = [FavoriteGameModel]
    
    private var remoteRepository: RemoteRepository? = nil
    private var localeRepository: FavoriteGameRepositoryProtocol? = nil
    
    public init(
        remoteRepository: RemoteRepository
    ) {
        self.remoteRepository = remoteRepository
    }
    

    
    public func getData(request: Request?) -> Observable<[FavoriteGameModel]> {
        print("getAllFavoriteGameUseCase")
        
        return remoteRepository!.getData(request: nil)
            .map{
                var listGame: [FavoriteGameModel] = []
                for result in $0 {
                    let game = FavoriteGameModel(
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

extension FavoriteGameInteractor: FavoriteGameUseCase {
    
    public init(
        localeRepository: FavoriteGameRepositoryProtocol
    ) {
        self.localeRepository = localeRepository
    }
    
    public func add(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool> {
        return localeRepository!.add(
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
        return localeRepository!.removeByID(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    public func checkByID(
        _ id: Int
    ) -> Observable<Bool> {
        return localeRepository!.checkByID(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}
