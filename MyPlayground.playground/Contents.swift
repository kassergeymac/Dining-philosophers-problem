import UIKit
import PlaygroundSupport

enum PhilosopherState {
    case eating
    case restingAfterEating
    case restingAfterFailToEat
}

class Philosopher {
    let name: String
    
    let eatingTime: Int
    let restingTimeAfterEating: Int
    let restingTimeAfterFailToEat: Int
    
    var forkLeft: Fork
    var forkRight: Fork
    
    var busyFork: Fork? = nil
    
    var state: PhilosopherState = PhilosopherState.restingAfterEating
    var currentTickCounter: Int = 0
    
    init(name: String, eatingTime: Int, restingTimeAfterEating: Int, restingTimeAfterFailToEat: Int, forkLeft:Fork, forkRight:Fork) {
        self.name = name
        self.eatingTime = eatingTime
        self.restingTimeAfterEating = restingTimeAfterEating
        self.restingTimeAfterFailToEat = restingTimeAfterFailToEat
        self.forkLeft = forkLeft
        self.forkRight = forkRight
    }
    
    func tick() {
        self.currentTickCounter += 1
        if self.state == .eating {
            if(self.currentTickCounter == self.eatingTime) {
                print("Philosopher \(name) put fork with id \(self.busyFork?.id)")
                self.busyFork?.isBusy = false
                self.busyFork = nil
                self.state = .restingAfterEating
                self.currentTickCounter = 0
            }
            return
        }
        if self.state == .restingAfterEating {
            if(self.currentTickCounter == self.restingTimeAfterEating) {
                if ((!self.forkLeft.isBusy) && (!self.forkRight.isBusy)) {
                    self.eatWithFork(self.forkLeft)
                    return
                }
                print("Philosopher \(name) failed to eat.")
                self.state = .restingAfterFailToEat
                self.currentTickCounter = 0
            }
            return
        }
        if self.state == .restingAfterFailToEat {
            if(self.currentTickCounter == self.restingTimeAfterEating) {
                if ((!self.forkLeft.isBusy) && (!self.forkRight.isBusy)) {
                    self.eatWithFork(self.forkLeft)
                    self.eatWithFork(self.forkRight)
                    return
                }
                print("Philosopher \(name) failed to eat.")
                self.state = .restingAfterFailToEat
                self.currentTickCounter = 0
            }
            return
        }
    }
    
    private func eatWithFork(_ fork: Fork) {
        self.busyFork = fork
        self.busyFork?.isBusy = true
        self.state = .eating
        self.currentTickCounter = 0
        print("Philosopher \(name) took fork with id \(self.busyFork?.id)")
    }
}

struct Fork {
    let id: Int
    var isBusy: Bool
}

let forks = [Fork(id: 1, isBusy: false),
             Fork(id: 2, isBusy: false),
             Fork(id: 3, isBusy: false),
             Fork(id: 4, isBusy: false),
             Fork(id: 5, isBusy: false)]

let philosophers = [Philosopher(name: "1",
                                eatingTime: 2,
                                restingTimeAfterEating: 2,
                                restingTimeAfterFailToEat: 1,
                                forkLeft:forks[0],
                                forkRight:forks[1]),
                    Philosopher(name: "2",
                                eatingTime: 2,
                                restingTimeAfterEating: 2,
                                restingTimeAfterFailToEat: 2,
                                forkLeft:forks[1],
                                forkRight:forks[2]),
                    Philosopher(name: "3",
                                eatingTime: 3,
                                restingTimeAfterEating: 2,
                                restingTimeAfterFailToEat: 2,
                                forkLeft:forks[2],
                                forkRight:forks[3]),
                    Philosopher(name: "4",
                                eatingTime: 4,
                                restingTimeAfterEating: 2,
                                restingTimeAfterFailToEat: 2,
                                forkLeft:forks[3],
                                forkRight:forks[4]),
                    Philosopher(name: "5",
                                eatingTime: 5,
                                restingTimeAfterEating: 2,
                                restingTimeAfterFailToEat: 2,
                                forkLeft:forks[4],
                                forkRight:forks[0])]

func configureTimerWithPhilosopher(_ philosopher: Philosopher) -> DispatchSourceTimer {
    let dispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .userInitiated))
    dispatchSourceTimer.schedule(deadline: DispatchTime.now(), repeating: 1)
    dispatchSourceTimer.setEventHandler(handler: { philosopher.tick() })
    dispatchSourceTimer.resume()
    return dispatchSourceTimer
}

//это для мемори менеджмента, просто смиритесь
let savedTimers = [configureTimerWithPhilosopher(philosophers[0]),
                   configureTimerWithPhilosopher(philosophers[1]),
                   configureTimerWithPhilosopher(philosophers[2]),
                   configureTimerWithPhilosopher(philosophers[3]),
                   configureTimerWithPhilosopher(philosophers[4])]
