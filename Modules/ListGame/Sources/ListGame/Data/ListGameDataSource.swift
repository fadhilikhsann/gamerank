//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import RxSwift
import CoreModule

public struct ListGameDataSource: DataSourceDelegate {
    
    public typealias Request = Any
    public typealias Response = [ListGameEntity]
    
    let key: String = "464b5d9e21aa405eb22a7afe999aae76"
    
    public init(){}
    
    public func getResponse(
        path: String,
        queryItems: [URLQueryItem],
        _ completion: @escaping (Result<(Data, URLResponse), Error>) -> Void
    ) {
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.rawg.io"
            components.path = path
            components.queryItems = queryItems
            return components.url!
        }
        
        
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            
            if response.statusCode == 200 {
                print("Response Success")
                completion(.success((data, response)))
            } else {
                print("Response Failed because \(String(describing: error))")
                completion(.failure(error!))
            }
            
        }
        
        task.resume()
        
    }
    
    public func getData(request: Any?) -> Observable<[ListGameEntity]> {
        
        var listGame: [ListGameEntity] = []
        let task = DispatchGroup()
        task.enter()
        getResponse(
            path: "/api/games",
            queryItems: [
                URLQueryItem(
                    name: "key",
                    value: key
                )
            ],
            { result in
                print("ENTER")
                switch result {
                case .failure(let error):
                    print(error)
                    break
                case .success(let data):
                    let decoder = JSONDecoder()
                    
                    if let gamesData = try? decoder.decode(GameResponse.self, from: data.0) as GameResponse {
                        print("Jumlah data: \(gamesData.listGame!.count)")
                        
                        for result in gamesData.listGame! {
                            let game = ListGameEntity(
                                forId: result.idGame,
                                forName: result.nameGame!,
                                forReleasedDate: result.releasedGame!,
                                forUrlImage: result.urlImageGame!,
                                forRating: result.ratingGame
                            )
                            listGame.append(game)
                        }
                        
                        
                        
                    } else {
                        print("ERROR: Can't Decode JSON")
                    }
                    break
                }
                task.leave()
            }
        )
        task.wait()
        print("Jumlah datanya: \(listGame.count)")
        return Observable.from(optional: listGame)
        
    }
    
}
