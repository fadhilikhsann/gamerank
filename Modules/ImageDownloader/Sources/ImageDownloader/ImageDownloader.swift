//
//  File.swift
//
//
//  Created by Fadhil Ikhsanta on 06/01/23.
//

import Foundation
import UIKit

public enum DownloadState {
    case new, downloaded, failed
}

public class ImageDownloader: Operation {

    public var _model: UIImageModel
 
    public init(model: UIImageModel) {
        _model = model
    }
    
    public override func main() {
        if isCancelled {
            return
        }

        guard let imageData = try? Data(contentsOf: _model.urlImage!) else { return }
 
        if isCancelled {
            return
        }

        if !imageData.isEmpty {
            _model.image = UIImage(data: imageData)
            _model.state = .downloaded
        } else {
            _model.image = nil
            _model.state = .failed
        }
    }

}
