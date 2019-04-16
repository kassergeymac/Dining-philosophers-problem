//
//  Waiter.swift
//  PhilosopherProblem
//
//  Created by kassergey on 3/20/19.
//  Copyright © 2019 kassergey. All rights reserved.
//

import Foundation

class Waiter {
    let forks: [Fork]
    
    init(forks: [Fork]) {
        self.forks = forks
    }
    
    func allowedTakeForks() -> Bool {
        let takenForksCount = self.forks.filter { $0.pickedUp == false }.count
        return takenForksCount != 1
    }
}
