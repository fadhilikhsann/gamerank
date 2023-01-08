//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 08/01/23.
//

import Foundation
import UIKit

public class UIImageModel {

    public var urlImage: URL? = nil
    public var image: UIImage? = nil
    public var state: DownloadState = .new
    
    public init(
        forUrlImage urlImage: URL
    ){
        self.urlImage = urlImage
    }
}
