//
//  ImageDownloader.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 17/06/22.
//

import Foundation
import UIKit

class ImageDownloader: Operation {
 
//    private var _game: GameModel
//
//    init(game: GameModel) {
//        _game = game
//    }
 
    private var _game: GameEntity
 
    init(game: GameEntity) {
        _game = game
    }
    
    override func main() {
        if isCancelled {
            return
        }
 
        guard let imageData = try? Data(contentsOf: _game.urlImageGame!) else { return }
 
        if isCancelled {
            return
        }
 
        if !imageData.isEmpty {
            _game.imageGame = UIImage(data: imageData)
            _game.state = .downloaded
        } else {
            _game.imageGame = nil
            _game.state = .failed
        }
    }

}
