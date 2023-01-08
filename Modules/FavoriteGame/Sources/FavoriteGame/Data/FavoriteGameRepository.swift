//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 07/01/23.
//

import Foundation
import RxSwift
import CoreModule

public struct FavoriteGameRepository<
    RemoteDataSource: DataSourceDelegate
>: RepositoryDelegate
where
RemoteDataSource.Response == [FavoriteGameEntity]
{

    public typealias Request = Any
    
    public typealias Response = [FavoriteGameEntity]
    
    private var remoteDataSource: RemoteDataSource? = nil
    private var localeDataSource: FavoriteGameDataSourceProtocol? = nil
    private var disposeBag = DisposeBag()
    
    public init(
        remoteDataSource: RemoteDataSource
    ) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func getData(request: Request?) -> Observable<[FavoriteGameEntity]> {
        return remoteDataSource!.getData(request: nil)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    

    
}

extension FavoriteGameRepository: FavoriteGameRepositoryProtocol {
    
    public init(
        localeDataSource: FavoriteGameDataSourceProtocol
    ) {
        self.localeDataSource = localeDataSource
    }
    
    public func add(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool> {
        print("addFavoriteGamesRepository")
        return localeDataSource!.add(
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
        return localeDataSource!.removeByID(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    public func checkByID(
        _ id: Int
    ) -> Observable<Bool> {
        return localeDataSource!.checkByID(id)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

extension FavoriteGameRepository: FavoriteGameDataSourceProtocol {
    
}
