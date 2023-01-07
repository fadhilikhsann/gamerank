//
//  SceneDelegate.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 14/06/22.
//

import UIKit
import Swinject
import ListGame

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

        let container: Container = {
            let container = Container()
            container.register(ListGameUseCase.self) { _ in ListGameInjection.init().provideGameUseCase() }
            container.register(ListGamePresenter.self) { r in ListGamePresenter(useCase: r.resolve(ListGameUseCase.self)!) }
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
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

