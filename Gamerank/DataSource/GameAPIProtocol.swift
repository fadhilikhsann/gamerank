//
//  ApiProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 27/11/22.
//

import Foundation
import RxSwift

protocol GameAPIProtocol {
    var url: URL? { get }
    func getResponse(
        path: String,
        queryItems: [URLQueryItem],
        _ completion: @escaping (Result<(Data, URLResponse), Error>) -> Void
    )
    func getListGame() -> Observable<[ListGameEntity]>
    func getDetailGame(idGame: Int) -> Observable<DetailGameEntity>
    func getAllFavoriteGame() -> Observable<[ListGameEntity]>
}
