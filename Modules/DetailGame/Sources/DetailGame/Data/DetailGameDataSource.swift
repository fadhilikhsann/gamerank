//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import RxSwift
import CoreModule

public struct DetailGameDataSource: DataSourceDelegate {
    
    public typealias Request = Int
    public typealias Response = DetailGameEntity
    
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
    
    public func getData(request: Int?) -> Observable<DetailGameEntity> {
        var detailGame: DetailGameEntity? = nil
        let task = DispatchGroup()
        task.enter()
        getResponse(
            path: "/api/games/\(request ?? 0)",
            queryItems: [
                URLQueryItem(
                    name: "key",
                    value: key
                )
            ],
            { result in
                switch result {
                case .failure(let error):
                    print(error)
                    break
                case .success(let data):
                    let decoder = JSONDecoder()
                    
                    if let gameData = try? decoder.decode(DetailGameResponse.self, from: data.0) as DetailGameResponse {
                        
                        detailGame = DetailGameEntity(
                            forId: gameData.idGame,
                            forName: gameData.nameGame!,
                            forReleasedDate: gameData.releasedGame!,
                            forUrlImage: gameData.urlImageGame!,
                            forRating: gameData.ratingGame,
                            forDescription: gameData.descriptionGame!
                        )
                        
                    } else {
                        print("ERROR: Can't Decode JSON")
                        detailGame = nil
                    }
                    break
                }
                task.leave()
            }
        )
        task.wait()
        return Observable.from(optional: detailGame!)
        
    }
    
}
