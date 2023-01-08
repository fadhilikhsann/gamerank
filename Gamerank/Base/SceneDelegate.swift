//
//  SceneDelegate.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 14/06/22.
//

import UIKit
import Swinject
import ListGame
import CoreModule

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    let container: Container = {
        let container = Container()
        
        
        container.register(
            ListGameInteractor<
            ListGameRepository<
            ListGameDataSource
            >>.self
        ) { _ in ListGameInjection.init().provideUseCase() }
        container.register(ListGamePresenter.self) { r in ListGamePresenter(useCase: r.resolve(
            ListGameInteractor<
            ListGameRepository<
            ListGameDataSource
            >>.self
        )!) }
        container.register(ListGameViewController.self) { r in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if let controller = storyBoard.instantiateViewController(withIdentifier: "GameList") as? ListGameViewController{
                controller.listGamePresenter = r.resolve(ListGamePresenter.self)
                return controller
            }
            
            return ListGameViewController()
            
        }
        return container
    }()
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
        let windowScene = UIWindowScene(session: session, connectionOptions: connectionOptions)
        self.window = UIWindow(windowScene: windowScene)
        
        let rootVC = UINavigationController(rootViewController: container.resolve(ListGameViewController.self)!)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
    
    
}

