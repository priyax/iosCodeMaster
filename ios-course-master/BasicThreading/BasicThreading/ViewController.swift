//
//  ViewController.swift
//  BasicThreading
//
//  Created by Kevin Harris on 2/1/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var mySharedValue = 0
    
    var lock = NSLock()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //
        // As soon as the view loads, we'll start two threads:
        //
        
        launchThread1()
        launchThread2()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The job of this test function is to demonstrate the NON-thread-safe
    // way to modify some shared data.
    func unsafeValueIncrement() {
        
        for _ in 0..<1000 {
            
            let v = mySharedValue + 1
            print("mySharedValue = \(v)")
            mySharedValue = v
        }
    }
    
    // The job of this test function is to demonstrate the thread-safe
    // way to modify some shared data.
    func safeValueIncrement() {
        
        for _ in 0..<1000 {
            
            lock.lock()
            
            let v = mySharedValue + 1
            print("mySharedValue = \(v)")
            mySharedValue = v
            
            lock.unlock()
        }
    }
    
    // It's also possible to lock access to a variable by using calls to
    // objc_sync_enter and objc_sync_exit where you pass in some instance
    // object to lock on. Here's a version of function above which uses
    // objc_sync_enter and objc_sync_exit instead of a NSLock:
//    func incrementValue1000() {
//
//        for _ in 0..<1000 {
//
//            objc_sync_enter(self)
//
//            let v = mySharedValue + 1
//            print("mySharedValue = \(v)")
//            mySharedValue = v
//
//            objc_sync_exit(self)
//        }
//    }
    
    func launchThread1() {
        
        let myThread1 = Thread(target:self, selector:#selector(threadMain1(_:)), object:self)
        myThread1.start()
        
        // If you don't need access to the thread instance, you can call
        // NSThread.detachNewThreadSelector instead.
        //NSThread.detachNewThreadSelector("threadMain1:", toTarget:self, withObject:self)
    }
    
    func threadMain1(_ sender: ViewController) {
        
        //sender.unsafeValueIncrement()
        sender.safeValueIncrement()
        
        print("NSThread #1 done!")
    }
    
    func launchThread2() {
        
        let myThread2 = Thread(target:self, selector:#selector(threadMain2(_:)), object:self)
        myThread2.start()
    }
    
    func threadMain2(_ sender: ViewController) {
        
        //sender.unsafeValueIncrement()
        sender.safeValueIncrement()
        
        print("NSThread #2 done!")
    }
}

