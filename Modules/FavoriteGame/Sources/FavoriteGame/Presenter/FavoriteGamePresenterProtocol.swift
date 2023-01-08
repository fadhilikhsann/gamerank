//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 07/01/23.
//

import Foundation
import RxSwift

public protocol FavoriteGamePresenterProtocol {
    func add(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool>
    func checkByID(
        _ id: Int
    ) -> Observable<Bool>
    func removeByID(
        _ id: Int
    ) -> Observable<Bool>
}
