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
    private(set) var philosopher: Philosopher?
    
    @discardableResult
    func setPhilosopher(_ philosopher: Philosopher) -> Bool {
        semaphore.wait()
        if (self.philosopher != nil) && (self.philosopher != philosopher) {
            semaphore.signal()
            return false
        }
        self.philosopher = philosopher
        semaphore.signal()
        return true
    }
    
    @discardableResult
    func unsetPhilosopher(_ philosopher: Philosopher) -> Bool {
        semaphore.wait()
        if (self.philosopher != philosopher) {
            semaphore.signal()
            return false
        }
        self.philosopher = nil
        semaphore.signal()
        return true
    }
    
    init(id: Int) {
        self.id = id
    }
}
