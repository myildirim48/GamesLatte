//
//  Debouncer.swift
//  LatteGames
//
//  Created by YILDIRIM on 8.03.2023.
//

import Foundation
class Debouncer {
    private var workItem: DispatchWorkItem = DispatchWorkItem { }
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval
    
    init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }
    
    func debounce(_ block: @escaping () -> Void){
        workItem.cancel()
        
        workItem = DispatchWorkItem{ [weak self] in
            self?.previousRun = Date()
            block()
        }
        
        let delay = previousRun.timeIntervalSince1970 > minimumDelay ? 0 : minimumDelay
        queue.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
    }
}
