//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import CoreModule
import RxSwift

public struct ListGameRepository<
    DataSource: DataSourceDelegate
>: RepositoryDelegate
where
DataSource.Response == [ListGameEntity]
{
    public typealias Request = Any
    
    public typealias Response = [ListGameEntity]
    
    
    public var dataSource: DataSource
    public var disposeBag = DisposeBag()
    
    public init(
        dataSource: DataSource
    ) {
        self.dataSource = dataSource
    }
    
    public func getData(request: Any?) -> Observable<[ListGameEntity]> {
        return dataSource.getData(request: nil )
            .map{$0}
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}
