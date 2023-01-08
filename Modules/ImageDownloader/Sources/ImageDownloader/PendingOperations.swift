//
//  File.swift
//  
//
//  Created by Fadhil Ikhsanta on 06/01/23.
//

import Foundation

public class PendingOperations {
    
    public init(){}
    
    public lazy var downloadInProgress: [IndexPath: Operation] = [:]
 
    public lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.fadhilikhsann.imagedownload"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
 
}
