//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 06/01/23.
//

import Foundation
import CoreData
import RxSwift
import CoreModule


public struct FavoriteGameDataSource: DataSourceDelegate {
    
    public typealias Request = Any
    
    public typealias Response = [FavoriteGameEntity]
    
    public init(){
        
    }
    
    public func getData(request: Request?) -> RxSwift.Observable<[FavoriteGameEntity]> {
        let taskContext = newTaskContext()
        
        let listGame = taskContext.performAndWait {
            var listGame: [FavoriteGameEntity] = []
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            do {
                let results = try taskContext.fetch(fetchRequest)
                print("\(results.count) Jumlah")
                for result in results {
                    let game = FavoriteGameEntity(
                        forId: (result.value(forKeyPath: "id") as! Int),
                        forName: (result.value(forKeyPath: "name") as! String),
                        forReleasedDate: (result.value(forKeyPath: "releasedDate") as! Date),
                        forUrlImage: (result.value(forKeyPath: "urlImage") as! URL),
                        forRating: (result.value(forKeyPath: "rating") as! Double)
                    )
                    listGame.append(game)
                }
                return listGame
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            return []
        }
        print("Jumlah: \(listGame.count)")
        return Observable.from(optional: listGame)
    }
    
}

extension FavoriteGameDataSource: FavoriteGameDataSourceProtocol {
    

    
    public var persistentContainer: NSPersistentContainer {
        
        guard
            let objectModelURL = Bundle.module.url(forResource: "FavoriteGame", withExtension: "momd"),
            let objectModel = NSManagedObjectModel(contentsOf: objectModelURL)
        else {
            fatalError("Failed to retrieve the object model")
        }
        
        let container = NSPersistentContainer(name: "FavoriteGame", managedObjectModel: objectModel)
        
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
    
    public func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    public func add(
        _ idGame: Int,
        _ nameGame: String,
        _ releasedGame: Date,
        _ urlImageGame: URL,
        _ ratingGame: Double
    ) -> Observable<Bool> {
        let taskContext = newTaskContext()
        
        let isSuccess = taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Game", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(idGame, forKeyPath: "id")
                game.setValue(nameGame, forKeyPath: "name")
                game.setValue(releasedGame, forKeyPath: "releasedDate")
                game.setValue(urlImageGame, forKeyPath: "urlImage")
                game.setValue(ratingGame, forKeyPath: "rating")
                do {
                    try taskContext.save()
                    return true
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            return false
        }
        
        return Observable.from(optional: isSuccess)
    }
    
    public func removeByID(_ id: Int) -> Observable<Bool> {
        let taskContext = newTaskContext()
        
        let isSuccess = taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    return true
                }
            }
            return false
        }
        
        return Observable.from(optional: isSuccess)
    }
    
    public func checkByID(_ id: Int) -> Observable<Bool> {
        let taskContext = newTaskContext()
        
        let isSuccess = taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).count as Int?{
                    switch(result){
                    case 0:
                        break
                    default:
                        return true
                    }
                    
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            return false
        }
        
        return Observable.from(optional: isSuccess)
    }
    
    
}

