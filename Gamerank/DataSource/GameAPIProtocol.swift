//
//  ApiProtocol.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 27/11/22.
//

import Foundation

protocol GameAPIProtocol {
    var url: URL? { get }
    func getResponse(
        path: String,
        queryItems: [URLQueryItem],
        _ completion: @escaping (Result<(Data, URLResponse), Error>) -> Void
    )
    func getListGame() -> [GameEntity]
    func getDetailGame(idGame: Int) -> GameEntity
    func getAllFavoriteGame() -> [GameEntity]
}
