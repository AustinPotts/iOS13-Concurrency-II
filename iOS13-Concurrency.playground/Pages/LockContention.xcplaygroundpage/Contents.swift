//: [Previous](@previous)

import Foundation



// Example #5





var sharedResource = 0

let lock = NSLock()

// allows to run a different run of collections in a group and allows to span across multiple threads
let group = DispatchGroup()

let numberOfIterations = 20_000

var startTime = Date()

// For loop running 20,000 times
for _ in 0..<numberOfIterations {
    group.enter()
    // Offloading work to global queue
    DispatchQueue.global().async {
        lock.lock()
         // Not copying, but accessing the shared resource in the group
        sharedResource += 1
        
        lock.unlock()
        
        group.leave()
    }
}

group.wait() //Wait for the work to finish of the group

var endTime = Date()
var elapsedTime = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate

print("Time elapsed to add\(numberOfIterations): \(elapsedTime) seconds")


// Using Queues
sharedResource = 0

let myQueue = DispatchQueue(label: "Shared Access Queue")

startTime = Date()

for _ in 0..<numberOfIterations {
    group.enter()
    myQueue.async {
        sharedResource += 1
        group.leave()
    }
    
}
group.wait()

endTime = Date()
elapsedTime = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate

print("Time elapsed to add\(numberOfIterations): \(elapsedTime) seconds")

//: [Next](@next)
