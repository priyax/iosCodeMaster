
import UIKit
import PlaygroundSupport // Needed to support asynchronous code in this sample.

//------------------------------------------------------------------------------

// Closures
//
// Just like functions, closures are self-contained blocks of code, but they 
// can be assigned to variables and passed into functions. Closures in Swift 
// are similar to lambda functions in other programming languages or blocks 
// in Objective-C.


// A function is basically just a closure that is named.
func sayHelloFunc() {
    print("Function says, Hello!")
}

// Here we use the function.
sayHelloFunc()


// Below is a variable that points to a closure. It looks a little weird but
// the variable's type is this:
//
//() -> ()
//
// Which means the variable's type is a closure that takes no arguments
// and returns no values.

var sayHelloClosure: () -> () = {
    print("Closure says, Hello!")
}

// Now, even though sayHelloClosure is a variable, it does point to a closure 
// which is a block of code and therefore can be called just like a function.

sayHelloClosure()


//------------------------------------------------------------------------------

// Here's another function that has two parameters and a return type:

func combineTextFunc(text1: String, text2: String) -> String {
    
    return text1 + text2
}

print(combineTextFunc(text1: "Text combined by a ", text2:"function!"))


// Again, we'll create a variable that points to a closure which is capable of
// doing the same thing as the combineTextFunc function above. Note the
// variable's type:
//
// (String, String) -> String
//
// Which means the variable's type is a closure that takes two arguments
// of type String and returns a String.


var combineTextClosure: (String, String) -> String


// Later, we can initialize the 'combineTextClosure' var by assigning a
// closure to it, but the syntax will look a bit different than we saw
// above because we now must deal with parameters.

combineTextClosure = { (text1: String, text2: String) -> String in

    return text1 + text2
}

// We could also initialize it like this where the () are dropped, the
// parameter types are infered, and a call to return is just assumed
// upon reaching the last line.

combineTextClosure = { (text1 : String , text2 : String) -> String in
    
    text1 + text2
}

// We can even initialize it like this... where all type are inferred and 
// Swift allows us to talk about the arguments using place-holder substitutions.

combineTextClosure = {
    $0 + $1
}

// Finally, test our closure here!
print(combineTextClosure("Text combined by a ", "closure!"))

//------------------------------------------------------------------------------

// Ok, so closures are basically blocks of code that we can pass around like
// variables, but what are closures good for?

// Most often in iOS development, you'll run into a closure as being the type
// required by a parameter of a function. In this common case, the closure is
// being used as a callback which the function can use to "call back" to the
// programmer. When the function calls back with the closure, the programmer
// will have a chance to execute some code depending on what happened in the
// function.

// The function below will take a closure and delay the execution of it for
// the number of seconds specified. The parameter name for the closure is
// 'workClosure' and it takes a single string as an argument and returns
// nothing: (String) -> ()

func doSomeDelayedWork(timeToDelay: Double, workToDo: @escaping (String) -> ()) {
    
    // We'll use a call to DispatchQueue.main.asyncAfter to delay the execution 
    // of some number of seconds in the future.

    let dispatchTime = DispatchTime.now() + Double(Int64(timeToDelay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
        
        // Put the code which should be executed with a delay here:

        // Since the parameter 'workClosure' is a closure, we can execute
        // it's code by calling the closure like a function.
        workToDo("Calling closure delayed for \(timeToDelay) seconds!")
    })
}

// To test our function that takes a closure, we could create a closure 
// that matches the closure type specified by the function above called 
// 'doSomeDelayedWork' and then pass it as an argument like so.

var myWorkToDelay: (String) -> () = { message in
    print(message)
}

doSomeDelayedWork(timeToDelay: 2, workToDo: myWorkToDelay)


// Of course, it is more typical to see the closure passed directly into the
// function call instead being assigned to a var first.
doSomeDelayedWork(timeToDelay: 4, workToDo: { message in print(message) })


// Here's how to call the same function using the Trailing Closure syntax.
// Trailing closures are most useful when the code in the closure is too 
// complex to write out as a single line of code.
doSomeDelayedWork(timeToDelay: 6) { message in
    print(message)
}


// Since this sample makes use of some asynchronous code, we will need to tell
// them playground to continue spinning the main run loop, so the asynchronous
// code has a chance to run till completion.

PlaygroundPage.current.needsIndefiniteExecution = true
