//
//  ViewController.swift
//  PhilosopherProblem
//
//  Created by kassergey on 3/17/19.
//  Copyright © 2019 kassergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var savedTimers: [DispatchSourceTimer]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        enum PhilosopherState {
            case eating
            case restingAfterEating
            case restingAfterFailToEat
        }
        
        class Philosopher: NSObject {
            let name: String
            var dispatchSourceTimer: DispatchSourceTimer?
            
            let eatingTime: Int
            let restingTimeAfterEating: Int
            let restingTimeAfterFailToEat: Int
            
            var failToEatCounter: Int = 0 {
                didSet {
                    if failToEatCounter == 5 {
                        print("Philosopher \(name) died")
                        self.dispatchSourceTimer?.cancel()
                    }
                }
            }
            
            var forkLeft: Fork
            var forkRight: Fork
            
            var state: PhilosopherState = PhilosopherState.restingAfterEating
            var currentTickCounter: Int = 0
            
            init(name: String, eatingTime: Int, restingTimeAfterEating: Int, restingTimeAfterFailToEat: Int, forkLeft:Fork, forkRight:Fork) {
                self.name = name
                self.eatingTime = eatingTime
                self.restingTimeAfterEating = restingTimeAfterEating
                self.restingTimeAfterFailToEat = restingTimeAfterFailToEat
                self.forkLeft = forkLeft
                self.forkRight = forkRight
                super.init()
            }
            
            func tick() {
                self.currentTickCounter += 1
                if self.state == .eating {
                    if(self.currentTickCounter == self.eatingTime) {
                        self.failToEatCounter = 0
                        print("Philosopher \(name) put fork \(self.forkLeft.id) and fork \(self.forkRight.id)")
                        self.forkLeft.unsetPhilosopher(self)
                        self.forkRight.unsetPhilosopher(self)
                        self.state = .restingAfterEating
                        self.currentTickCounter = 0
                    }
                    return
                }
                if self.state == .restingAfterEating {
                    if(self.currentTickCounter == self.restingTimeAfterEating) {
                        if ((!self.forkLeft.setPhilosopher(self)) && (!self.forkRight.setPhilosopher(self))) {
                            self.eatWithFork(self.forkLeft)
                            self.eatWithFork(self.forkRight)
                            return
                        }
                        self.forkLeft.unsetPhilosopher(self)
                        self.forkRight.unsetPhilosopher(self)
                        print("Philosopher \(name) failed to eat.")
                        self.failToEatCounter = self.failToEatCounter + 1
                        self.state = .restingAfterFailToEat
                        self.currentTickCounter = 0
                    }
                    return
                }
                if self.state == .restingAfterFailToEat {
                    if(self.currentTickCounter == self.restingTimeAfterEating) {
                        if ((!self.forkLeft.setPhilosopher(self)) && (!self.forkRight.setPhilosopher(self))) {
                            self.eatWithFork(self.forkLeft)
                            self.eatWithFork(self.forkRight)
                            return
                        }
                        self.forkLeft.unsetPhilosopher(self)
                        self.forkRight.unsetPhilosopher(self)
                        print("Philosopher \(name) failed to eat.")
                        self.state = .restingAfterFailToEat
                        self.failToEatCounter = self.failToEatCounter + 1
                        self.currentTickCounter = 0
                    }
                    return
                }
            }
            
            private func eatWithFork(_ fork: Fork) {
                self.state = .eating
                self.currentTickCounter = 0
                print("Philosopher \(name) took fork \(fork.id)")
            }
            
            func configureTimerWithPhilosopher() {
                let dispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .userInitiated))
                dispatchSourceTimer.schedule(deadline: DispatchTime.now(), repeating: 1)
                dispatchSourceTimer.setEventHandler(handler: { self.tick() })
                dispatchSourceTimer.resume()
                self.dispatchSourceTimer = dispatchSourceTimer
            }
        }
        
        class Fork {
            let semaphore = DispatchSemaphore(value: 1)
            let id: Int
            private(set) var philosopher: Philosopher?
            
            @discardableResult
            func setPhilosopher(_ philosopher: Philosopher) -> Bool {
                self.semaphore.wait()
                if (self.philosopher != nil) && (self.philosopher != philosopher) {
                    self.semaphore.signal()
                    return false
                }
                self.philosopher = philosopher
                self.semaphore.signal()
                return true
            }
            
            @discardableResult
            func unsetPhilosopher(_ philosopher: Philosopher) -> Bool {
                self.semaphore.wait()
                if (self.philosopher != philosopher) {
                    self.semaphore.signal()
                    return false
                }
                self.philosopher = nil
                self.semaphore.signal()
                return true
            }
            
            init(id: Int) {
                self.id = id
            }
        }
        
        let forks = [Fork(id: 1),
                     Fork(id: 2),
                     Fork(id: 3),
                     Fork(id: 4),
                     Fork(id: 5)]
        
        let philosophers = [Philosopher(name: "1",
                                        eatingTime: 3,
                                        restingTimeAfterEating: 2,
                                        restingTimeAfterFailToEat: 1,
                                        forkLeft:forks[0],
                                        forkRight:forks[1]),
                            Philosopher(name: "2",
                                        eatingTime: 3,
                                        restingTimeAfterEating: 2,
                                        restingTimeAfterFailToEat: 2,
                                        forkLeft:forks[1],
                                        forkRight:forks[2]),
                            Philosopher(name: "3",
                                        eatingTime: 4,
                                        restingTimeAfterEating: 2,
                                        restingTimeAfterFailToEat: 2,
                                        forkLeft:forks[2],
                                        forkRight:forks[3]),
                            Philosopher(name: "4",
                                        eatingTime: 5,
                                        restingTimeAfterEating: 2,
                                        restingTimeAfterFailToEat: 2,
                                        forkLeft:forks[3],
                                        forkRight:forks[4]),
                            Philosopher(name: "5",
                                        eatingTime: 6,
                                        restingTimeAfterEating: 2,
                                        restingTimeAfterFailToEat: 2,
                                        forkLeft:forks[4],
                                        forkRight:forks[0])]
        
        
        //это для мемори менеджмента, просто смиритесь
        philosophers[0].configureTimerWithPhilosopher()
        philosophers[1].configureTimerWithPhilosopher()
        philosophers[2].configureTimerWithPhilosopher()
        philosophers[3].configureTimerWithPhilosopher()
        philosophers[4].configureTimerWithPhilosopher()

    }


}

