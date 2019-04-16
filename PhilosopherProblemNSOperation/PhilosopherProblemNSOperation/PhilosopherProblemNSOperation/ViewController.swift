//
//  ViewController.swift
//  PhilosopherProblemNSOperation
//
//  Created by kassergey on 4/16/19.
//  Copyright © 2019 kassergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var philosophers: [Philosopher]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let forks = [Fork(id: 1),
                     Fork(id: 2),
                     Fork(id: 3),
                     Fork(id: 4),
                     Fork(id: 5)]
        
        let waiter = Waiter(forks: forks)
        
        philosophers = [Philosopher(name: "1",
                                    eatingTime: 3,
                                    restingTimeAfterEating: 2,
                                    restingTimeAfterFailToEat: 1,
                                    forkLeft:forks[0],
                                    forkRight:forks[1]),
                        Philosopher(name: "2",
                                    eatingTime: 3,
                                    restingTimeAfterEating: 2,
                                    restingTimeAfterFailToEat: 1,
                                    forkLeft:forks[1],
                                    forkRight:forks[2]),
                        Philosopher(name: "3",
                                    eatingTime: 4,
                                    restingTimeAfterEating: 2,
                                    restingTimeAfterFailToEat: 1,
                                    forkLeft:forks[2],
                                    forkRight:forks[3]),
                        Philosopher(name: "4",
                                    eatingTime: 5,
                                    restingTimeAfterEating: 2,
                                    restingTimeAfterFailToEat: 1,
                                    forkLeft:forks[3],
                                    forkRight:forks[4]),
                        Philosopher(name: "5",
                                    eatingTime: 6,
                                    restingTimeAfterEating: 2,
                                    restingTimeAfterFailToEat: 1,
                                    forkLeft:forks[4],
                                    forkRight:forks[0])]
        
        for philosopher in philosophers {
            philosopher.waiter = waiter
        }
        
        philosophers[0].configureTimerWithPhilosopher()
        philosophers[1].configureTimerWithPhilosopher()
        philosophers[2].configureTimerWithPhilosopher()
        philosophers[3].configureTimerWithPhilosopher()
        philosophers[4].configureTimerWithPhilosopher()

    }


}

