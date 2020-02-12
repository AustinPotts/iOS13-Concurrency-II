//: [Previous](@previous)

import Foundation


var sharedResource = 10
var lock = NSLock()
// A simulated "operation" to talk to a Bluetooth/Serial device
// This operation takes at least 1 second to get a result
func syncDeviceMeasurement() {
    sleep(1) // waits synchronously X seconds
}
func doWorkOnMultipleThreads() -> Bool {
    
    var x = 5 // No locks required for non shared state
    
    lock.lock()
    sharedResource *= 10
    syncDeviceMeasurement()
    lock.unlock() // Unlock so we dont block during device communication
    
    lock.lock()
    if sharedResource < 1000 {
        lock.unlock()
        return false
    } else if sharedResource > 1000 && sharedResource < 1500 {
        x = sharedResource * 2
        lock.unlock()
        return true
    } else {
        sharedResource -= x
        lock.unlock()
    }
    
    //because we can early exit, we need to unlock for all cases
    // then grab the lock again for the next section
    lock.unlock()
    sharedResource += 5
    lock.unlock()
    return true
    
}
// How would you test the lock/unlock? Design your own test cases
//: ## Test Cases
//: All of these print statements should print out if there are no issues
print("doWork")
doWorkOnMultipleThreads()
print("finish: < 1000")
sharedResource = 1200
doWorkOnMultipleThreads()
print("finish: > 1000 && < 1500")
sharedResource = 2000
doWorkOnMultipleThreads()
print("finish: > 1500")



//: [Next](@next)
