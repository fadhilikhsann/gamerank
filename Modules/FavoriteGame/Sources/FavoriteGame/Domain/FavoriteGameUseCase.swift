//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 06/01/23.
//

import Foundation
import RxSwift

public protocol FavoriteGameUseCase {
    func add(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool>
    func removeByID(
        _ id: Int
    ) -> Observable<Bool>
    func checkByID(
        _ id: Int
    ) -> Observable<Bool>
    
}


