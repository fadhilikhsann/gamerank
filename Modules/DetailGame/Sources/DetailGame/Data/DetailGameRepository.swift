//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import RxSwift
import CoreModule

public struct DetailGameRepository<
    DataSource: DataSourceDelegate
>: RepositoryDelegate
where
DataSource.Request == Int,
DataSource.Response == DetailGameEntity
{
    public typealias Request = Int
    
    public typealias Response = DetailGameEntity
    
    
    public var dataSource: DataSource
    public var disposeBag = DisposeBag()
    
    public init(
        dataSource: DataSource
    ) {
        self.dataSource = dataSource
    }
    
    public func getData(request: Int?) -> Observable<DetailGameEntity> {
        return dataSource.getData(request: request ?? 0)
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))

    }
}
