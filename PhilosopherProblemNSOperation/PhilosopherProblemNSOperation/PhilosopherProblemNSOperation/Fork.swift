//
//  Fork.swift
//  PhilosopherProblem
//
//  Created by kassergey on 3/20/19.
//  Copyright © 2019 kassergey. All rights reserved.
//

import Foundation


class Fork {
    let id: Int
    let semaphore = DispatchSemaphore(value: 1)
    private(set) var pickedUp: Bool = true
    
    @discardableResult
    func pickUp() -> Bool {
        semaphore.wait()
        self.pickedUp = true
        return true
    }
    
    @discardableResult
    func pickDown() -> Bool {
        semaphore.signal()
        self.pickedUp = false
        return true
    }
    
    init(id: Int) {
        self.id = id
    }
}
