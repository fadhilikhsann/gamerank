//
//  ApiResponse.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 26/11/22.
//

import Foundation
import CoreData

class GameDataSource {
    let key: String = "464b5d9e21aa405eb22a7afe999aae76"
    var path: String? = nil
    var queryItems: [URLQueryItem]? = nil
    var listGame: [GameEntity]? = []
    var detailGame: GameEntity? = nil
    var idGame: Int = 0
}

extension GameDataSource: GameAPIProtocol {

    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.rawg.io"
        components.path = path ?? ""
        components.queryItems = queryItems
        return components.url!
    }
    
    func getResponse(
        path: String,
        queryItems: [URLQueryItem],
        _ completion: @escaping (Result<(Data, URLResponse), Error>) -> Void
    ) {
        self.path = path
        self.queryItems = queryItems
        
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
    
    func getListGame() -> [GameEntity] {
        print("getListGameDataSource")
        
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
                    
                    if let gamesData = try? decoder.decode(ApiRootEntity.self, from: data.0) as ApiRootEntity {
                        print("Jumlah data: \(gamesData.listGame!.count)")
                        self.listGame = gamesData.listGame!
                    } else {
                        print("ERROR: Can't Decode JSON")
                    }
                    break
                }
                task.leave()
            }
        )
        task.wait()
        print("Jumlah datanya: \(self.listGame!.count)")
        return self.listGame!
        
    }
    
    func getDetailGame(idGame: Int) -> GameEntity {
        print("getDetailGameDataSource")
        let task = DispatchGroup()
        task.enter()
        getResponse(
            path: "/api/games/\(idGame)",
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
                    
                    if let gameData = try? decoder.decode(GameEntity.self, from: data.0) as GameEntity {
                        
                        self.detailGame = gameData
                        
                    } else {
                        print("ERROR: Can't Decode JSON")
                        self.detailGame = nil
                    }
                    break
                }
                task.leave()
            }
        )
        task.wait()
        return self.detailGame!
    }
}

extension GameDataSource: GameCDProtocol {
    var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "FavoriteGame")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }
    
    func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllFavoriteGame() -> [GameEntity] {
        print("getAllFavoriteGameDataSource")
        let taskContext = newTaskContext()
        var games: [GameEntity] = []
        let task = DispatchGroup()
        task.enter()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            do {
                let results = try taskContext.fetch(fetchRequest)
                
                for result in results {
                    let game = GameEntity(
                        forId: (result.value(forKeyPath: "id") as! Int),
                        forName: (result.value(forKeyPath: "name") as! String),
                        forReleasedDate: (result.value(forKeyPath: "releasedDate") as! Date),
                        forUrlImage: (result.value(forKeyPath: "urlImage") as! URL),
                        forRating: (result.value(forKeyPath: "rating") as! Double)
                    )
                    games.append(game)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            task.leave()
        }
        task.wait()
        return games
    }
    
    func addFavoriteGame(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Bool {
        let taskContext = newTaskContext()
        let task = DispatchGroup()
        var isSuccess: Bool = false
        task.enter()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Game", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                    game.setValue(idGame, forKeyPath: "id")
                    game.setValue(nameGame, forKeyPath: "name")
                    game.setValue(releasedGame, forKeyPath: "releasedDate")
                    game.setValue(urlImageGame, forKeyPath: "urlImage")
                    game.setValue(ratingGame, forKeyPath: "rating")
                    do {
                        try taskContext.save()
                        isSuccess = true
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
            }
            task.leave()
        }
        task.wait()
        return isSuccess
    }
    
    func removeFavoriteGame(
        _ id: Int
    ) -> Bool {
        let taskContext = newTaskContext()
        let task = DispatchGroup()
        var isSuccess: Bool = false
        task.enter()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    isSuccess = true
                }
            }
            task.leave()
        }
        task.wait()
        return isSuccess
    }
    
    func checkFavoriteGame(
        _ id: Int
    ) -> Bool {
        let taskContext = newTaskContext()
        let task = DispatchGroup()
        var isSuccess: Bool = false
        task.enter()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            do {
                if let result = try taskContext.fetch(fetchRequest).count as Int?{
                    switch(result){
                    case 0:
                        break
                    default:
                        isSuccess = true
                        break
                    }
                    
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            task.leave()
        }
        task.wait()
        return isSuccess
    }
    
    func removeAllFavoriteGame() -> Bool {
        let taskContext = newTaskContext()
        let task = DispatchGroup()
        var isSuccess: Bool = false
        task.enter()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    isSuccess = true
                }
            }
            task.leave()
        }
        task.wait()
        return isSuccess
    }
}
