//
//  ApiInitializer.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 14/06/22.
//

import Foundation

struct ApiRequest{
    
    func request(
        endPoint apiEndPoint: ApiEndPoint,
        _ completion: @escaping (Result<(Data, URLResponse), Error>) -> Void){
            
            let request = URLRequest(url: apiEndPoint.url!)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse, let data = data else { return }
                
                if response.statusCode == 200 {
                    completion(.success((data, response)))
                } else {
                    completion(.failure(error!))
                }
                
            }
            
            task.resume()
            
        }
    
    
}

