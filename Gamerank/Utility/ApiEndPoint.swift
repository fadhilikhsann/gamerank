//
//  ApiEndPoint.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 14/06/22.
//

import Foundation

struct ApiEndPoint {
    let apiKey: String = "464b5d9e21aa405eb22a7afe999aae76"
    var path: String? = nil
    var queryItems: [URLQueryItem]? = nil
}

extension ApiEndPoint {
    
    func getDetailGame(
        id idGame: Int = 0) -> ApiEndPoint {
        return ApiEndPoint(
            path: "/api/games/\(idGame)",
            queryItems: [
                URLQueryItem(name: "key", value: apiKey)
            ]
        )
    }
    
    func getListGames() -> ApiEndPoint {
        return ApiEndPoint(
            path: "/api/games",
            queryItems: [
                URLQueryItem(name: "key", value: apiKey)
            ]
        )
    }
    
}

extension ApiEndPoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.rawg.io"
        components.path = path ?? ""
        components.queryItems = queryItems ?? nil

        return components.url
    }
}
