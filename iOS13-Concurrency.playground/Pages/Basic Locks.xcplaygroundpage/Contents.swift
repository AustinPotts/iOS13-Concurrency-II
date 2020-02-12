import Foundation

//Concurrency II


// Example #1

var x = 42
 
// Runs concurrently at the same time, paralel to eachother
DispatchQueue.concurrentPerform(iterations: 100) { _ in
    var localCopy = x
    localCopy += 1
    x = localCopy
}
// Race condition causes inaccurate value, doesn't know who gets to wrtie first
print(x)




// Mutext - Mutual Exclusion - run this 1 by 1
// There are many types of Mutexes

// Example #2

var sharedResource = 40

let lock = NSLock()


DispatchQueue.concurrentPerform(iterations: 100) { threadNumber in
    lock.lock()
    
    var copyOfResource = sharedResource
    copyOfResource += 1
    sharedResource = copyOfResource
    
    
    // The lock needs to be unlocked once it has completed
    lock.unlock()
}
 // Race condition is solved with NSlock's
print(sharedResource)


extension NSLock {
    
    func withLock(_ work: () -> Void){
        lock()
        work()
        unlock()
    }
    
}
DispatchQueue.concurrentPerform(iterations: 100) { threadNumber in
    lock.withLock {
         var copyOfResource = sharedResource
           copyOfResource += 1
           sharedResource = copyOfResource
    }
}

print(sharedResource)

// Creating a Defer extension for NSLock
extension NSLock {
    func withLockDefer(_ work: () -> Void) {
        lock()
        // Defer happens right before exiting this function. Runs at the end
        defer { // Keep this limited. Use Sparringly
        unlock()
        }
        work()
    }
}

DispatchQueue.concurrentPerform(iterations: 100) { threadNumber in
    lock.withLockDefer {
         var copyOfResource = sharedResource
           copyOfResource += 1
           sharedResource = copyOfResource
    }
}

print(sharedResource)




// Example #4
var listOfNames = [String]() // Array<String>()

let nameLock = NSLock()

//You can access array only in one single thread, otherwise you can corrupt the data isnide

URLSession.shared.dataTask(with: URL(string: "https://swapi.co/people/1/")!) { data, response, error in
    nameLock.lock()
    listOfNames.append("Luke")
    print(listOfNames)
    
    nameLock.unlock()
    }.resume()

URLSession.shared.dataTask(with: URL(string: "https://swapi.co/people/1/")!) { data, response, error in
    nameLock.lock()
    listOfNames.append("Leia")
    print(listOfNames)
    
    nameLock.unlock()
   }.resume()

URLSession.shared.dataTask(with: URL(string: "https://swapi.co/people/1/")!) { data, response, error in
    nameLock.lock()
    listOfNames.append("Han")
    print(listOfNames)
    
    nameLock.unlock()
   }.resume()

print("End \(listOfNames)")
