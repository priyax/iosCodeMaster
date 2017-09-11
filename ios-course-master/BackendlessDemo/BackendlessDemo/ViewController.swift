//
//  ViewController.swift
//  BackendlessDemo
//
//  Created by Kevin Harris on 3/16/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Don't forget to replace the App's ID and Secret Key in AppDelegate with YOUR own
    // from YOUR Backendless Dashboard!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    let EMAIL = "ios_user@gmail.com" // Doubles as User Name
    let PASSWORD = "password"
    
    let backendless = Backendless.sharedInstance()!
    
    class Comment: NSObject {
        
        var objectId: String?
        var message: String?
        var authorEmail: String?
        var topicId: Int = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkForBackendlessSetup() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.APP_ID == "<replace-with-your-app-id>" || appDelegate.SECRET_KEY == "<replace-with-your-secret-key>" {
            
            let alertController = UIAlertController(title: "Backendless Error",
                                                    message: "To use this sample you must register with Backendless, create an app, and replace the APP_ID and SECRET_KEY in the AppDelegate with the values from your app's settings.",
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        
        checkForBackendlessSetup()
        
        print( "registerBtn called!" )
        
        // In a real app, this where we would send the user to a register screen to collect their
        // user name and password for registering a new user. For testing purposes, we will simply
        // register a test user using a hard coded user name and password.
        let user: BackendlessUser = BackendlessUser()
        user.email = EMAIL as NSString!
        user.password = PASSWORD as NSString!
        
        backendless.userService.registering( user,
            
            response: { (user: BackendlessUser?) -> Void in
                print("User was registered: \(user?.objectId)")
            },
            
            error: { (fault: Fault?) -> Void in
                print("User failed to register: \(fault)")
            }
        )
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        
        checkForBackendlessSetup()
        
        print( "loginBtn called!" )
        
        // First, check if the user is already logged in. If they are, we don't need to
        // ask them to login again.
        let isValidUser = backendless.userService.isValidUserToken()
        
        if isValidUser != nil && isValidUser != 0 {
            
            // The user has a valid user token so we know for sure the user is already logged!
            print("User is already logged: \(isValidUser?.boolValue)");
            
        } else {
            
            // If we were unable to find a valid user token, the user is not logged in and they'll
            // need to login. In a real app, this where we would send the user to a login screen to
            // collect their user name and password for the login attempt. For testing purposes,
            // we will simply login a test user using a hard coded user name and password.
            
            // Please note for a user to stay logged in, we had to make a call to
            // backendless.userService.setStayLoggedIn(true) and pass true.
            // This asks that the user should stay logged in by storing or caching the user's login
            // information so future logins can be skipped next time the user launches the app.
            // For this sample this call was made in the AppDelegate in didFinishLaunchingWithOptions.
            
            backendless.userService.login( EMAIL, password: PASSWORD,
                
                response: { (user: BackendlessUser?) -> Void in
                    print("User logged in: \(user!.objectId)")
                },
                
                error: { (fault: Fault?) -> Void in
                    print("User failed to login: \(fault)")
                }
            )
        }
    }
    
    @IBAction func updateUserBtn(_ sender: UIButton) {
        
        if let currentUser = backendless.userService.currentUser {
        
            currentUser.setProperty("name", object: "Agent Smith" );
        
            // This is the other way to update an existing user.
//            let properties = [
//                "name" : "Agent Smith"
//            ]
//            currentUser.updateProperties(properties)
            
            backendless.userService.update(currentUser,
                                           
                response: { (user: Any?) -> Void in
                    
                    let user = user as! BackendlessUser
                    
                    print("User name was updated: \(user.objectId!), name: \(user.name!)")
                },
                
                error: { (fault: Fault?) -> Void in
                    print("User failed to update: \(fault)")
                })
        }
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0 ? true: false
    }
    
    @IBAction func createCommentBtn(_ sender: UIButton) {
        
        checkForBackendlessSetup()
        
        print( "createCommentBtn called!" )
        
        var topicId: Int
        
        if randomBool() {
            topicId = 1
        } else {
            topicId = 2
        }
        
        let comment = Comment()
        comment.message = "Hello, from iOS user!"
        comment.authorEmail = EMAIL
        comment.topicId = topicId
        
        backendless.data.save( comment,
            
            response: { (entity: Any?) -> Void in
                
                let comment = entity as! Comment
                
                print("Comment was saved: \(comment.objectId!), topicId: \(comment.topicId), message: \"\(comment.message!)\"")
            },
            
            error: { (fault: Fault?) -> Void in
                print("Comment failed to save: \(fault)")
            }
        )
    }
    
    @IBAction func findAllCommentsBtn(_ sender: UIButton) {
      
        checkForBackendlessSetup()
        
        print( "findAllCommentsBtn called!" )
        
        let dataStore = backendless.persistenceService.of(Comment.ofClass())
        
        dataStore?.find(
            
            { (comments: BackendlessCollection?) -> Void in

                print("Find attempt on all Comments has completed without error!")
                print("Number of Comments found = \((comments?.data.count)!)")
                
                for comment in (comments?.data)! {
                    
                    let comment = comment as! Comment
                    
                    print("Comment: \(comment.objectId!), topicId: \(comment.topicId), message: \"\(comment.message!)\"")
                }
            },
            
            error: { (fault: Fault?) -> Void in
                print("Comments were not fetched: \(fault)")
            }
        )
    }
    
    @IBAction func querySomeCommentsBtn(_ sender: UIButton) {
        
        checkForBackendlessSetup()
        
        print( "queryCommentsBtn called!" )
        
        let dataStore = self.backendless.data.of(Comment.ofClass())
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "topicId = 1"
        
        // Note: If you actually know the objectId of the object you want, you can set it like so.
        //dataQuery.whereClause = "objectId = 'D5134896-8270-EFD8-FFCB-EE27F38DA200'"
        
        // Find all the Comments where the topicId is equal to a certain number!
        dataStore?.find( dataQuery,
                        
            response: { (comments: BackendlessCollection?) -> Void in
                
                print("Find attempt on Comments with a certain topicId has completed without error!")
                print("Number of Comments found = \((comments?.data.count)!)")
                
                if (comments?.data.count)! > 0 {
                    
                    for comment in (comments?.data)! {
                        
                        let comment = comment as! Comment
                        
                        print("Comment: \(comment.objectId!), topicId: \(comment.topicId), message: \"\(comment.message!)\"")
                    }
                    
                } else {
                    print("No Comments were fetched using the whereClause '\(dataQuery.whereClause)'")
                }
            },
                        
            error: { ( fault: Fault?) -> Void in
                print("Comments were not fetched: \(fault)")
            }
        )
    }
    
    @IBAction func queryAndUpdateCommentsBtn(_ sender: UIButton) {
        
        checkForBackendlessSetup()
        
        print( "queryAndUpdateCommentsBtn called!" )

        let dataStore = self.backendless.data.of(Comment.ofClass())
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "topicId = 2"
        
        // Note: If you actually know the objectId of the object you want, you can set it like so.
        //dataQuery.whereClause = "objectId = 'D5134896-8270-EFD8-FFCB-EE27F38DA200'"
        
        // Find all the Comments where the topicId is equal to a certain number!
        // Once we find them - update or change the message on each comment found.
        dataStore?.find( dataQuery,
                         
             response: { (comments: BackendlessCollection?) -> Void in
                
                print("Find attempt on Comments with a certain topicId has completed without error!")
                print("Number of Comments found = \((comments?.data.count)!)")
                
                if (comments?.data.count)! > 0 {
                    
                    for comment in (comments?.data)! {
                        
                        let comment = comment as! Comment
                        
                        print("Comment: \(comment.objectId!), topicId: \(comment.topicId), message: \"\(comment.message!)\"")
                        
                        // Update or change the message for each comment we found.
                        comment.message = "I have been updated!!!!"
                        
                        self.backendless.data.save( comment,
                                                    
                            response: { (entity: Any?) -> Void in
                                
                                let comment = entity as! Comment
                                
                                print("Comment was updated: \(comment.objectId!), topicId: \(comment.topicId), message: \"\(comment.message!)\"")
                            },
                            
                            error: { (fault: Fault?) -> Void in
                                print("Comment failed to save: \(fault)")
                            }
                        )
                    }
                    
                } else {
                    print("No Comments were fetched using the whereClause '\(dataQuery.whereClause)'")
                }
            },
         
            error: { ( fault: Fault?) -> Void in
                print("Comments were not fetched: \(fault)")
            }
        )
    }
    
    @IBAction func removeAllCommentsBtn(_ sender: UIButton) {
        
        checkForBackendlessSetup()
        
        print( "removeAllCommentsBtn called!" )
        
        let dataStore = backendless.persistenceService.of(Comment.ofClass())
        
        // Find all the Comments!
        dataStore?.find(
            
            { (comments: BackendlessCollection?) -> Void in
                
                print("Find attempt on all Comments has completed without error!")
                print("Number of Comments found = \((comments?.data.count)!)")
                
                // Now, remove all the Comments we found - one by one!
                for comment in (comments?.data)! {
                    
                    let comment = comment as! Comment
                    
                    print("Remove Comment: \(comment.objectId!)")
                    
                    var error: Fault?
                    let result = dataStore?.remove(comment, fault: &error)
                    
                    if error == nil {
                        print("One Comment has been removed: \(result)")
                    } else {
                        print("Server reported an error on attempted removal: \(error)")
                    }
                }
            },
            
            error: { ( fault: Fault?) -> Void in
                print("Comments were not fetched: \(fault)")
            }
        )
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        
        checkForBackendlessSetup()
        
        print( "logoutBtn called!" )
        
        // First, check if the user is actually logged in.
        let isValidUser = backendless.userService.isValidUserToken()
        
        if isValidUser != nil && isValidUser != 0 {
            
            // If they are currently logged in - go ahead and log them out!
            
            backendless.userService.logout( { (user: Any!) -> Void in
                    print("User logged out!")
                },
                                           
                error: { (fault: Fault?) -> Void in
                    print("User failed to log out: \(fault)")
                }
            )
            
        } else {
            
            // If we were unable to find a valid user token, the user is already logged out.
            
            print("User is already logged out: \(isValidUser?.boolValue)");
        }
    }
}
