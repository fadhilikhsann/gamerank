//
//  ImageDownloader.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 17/06/22.
//

import Foundation
import UIKit

enum DownloadState {
    case new, downloaded, failed
}

class ImageDownloader: Operation {

    private var _game: ListGameUIModel
 
    init(game: ListGameUIModel) {
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
