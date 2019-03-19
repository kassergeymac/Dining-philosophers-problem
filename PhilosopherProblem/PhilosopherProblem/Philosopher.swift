//
//  Philosopher.swift
//  PhilosopherProblem
//
//  Created by kassergey on 3/20/19.
//  Copyright © 2019 kassergey. All rights reserved.
//

import Foundation

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
            if failToEatCounter == 10 {
                print("Philosopher \(name) died")
                self.dispatchSourceTimer?.cancel()
            }
        }
    }
    
    var forkLeft: Fork
    var forkRight: Fork
    
    var state: PhilosopherState = PhilosopherState.restingAfterEating
    var currentTickCounter: Int = 0
    
    var waiter: Waiter!
    
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
                if (self.waiter.allowedTakeForks()) {
                    guard self.forkLeft.setPhilosopher(self) && self.forkRight.setPhilosopher(self) else {
                        return
                    }
                    self.eatWithFork(self.forkLeft)
                    self.eatWithFork(self.forkRight)
                    return
                }
                //self.forkLeft.unsetPhilosopher(self)
                //self.forkRight.unsetPhilosopher(self)
                print("Philosopher \(name) failed to eat.")
                self.failToEatCounter = self.failToEatCounter + 1
                self.state = .restingAfterFailToEat
                self.currentTickCounter = 0
            }
            return
        }
        if self.state == .restingAfterFailToEat {
            if(self.currentTickCounter == self.restingTimeAfterEating) {
                if (self.waiter.allowedTakeForks()) {
                    guard self.forkLeft.setPhilosopher(self) && self.forkRight.setPhilosopher(self) else {
                        return
                    }
                    self.eatWithFork(self.forkLeft)
                    self.eatWithFork(self.forkRight)
                    return
                }
                //self.forkLeft.unsetPhilosopher(self)
                //self.forkRight.unsetPhilosopher(self)
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
