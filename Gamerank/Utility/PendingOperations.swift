//
//  PendingOperation.swift
//  Gamerank
//
//  Created by Fadhil Ikhsanta on 17/06/22.
//

import Foundation

class PendingOperations {
 
    lazy var downloadInProgress: [IndexPath: Operation] = [:]
 
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.dicoding.imagedownload"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
 
}
