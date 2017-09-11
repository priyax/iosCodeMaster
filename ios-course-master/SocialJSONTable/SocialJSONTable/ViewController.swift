//
//  ViewController.swift
//  SocialJSONTable
//
//  Created by Kevin Harris on 9/7/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tabelView: UITableView!
    
    struct SocialPost {
        let type: String
        let shares: Int
        let desc: String
    }
    
    var socialPosts = [SocialPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadJSONData()
        
        tabelView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    enum ReadFileFromResourcesError: Error {
        
        case fileDoesNotExist
        case failedToLoadData
        case failedToConvertData
    }
    
    func readFileFromResources(_ fileName: String, fileType: String, encoding: String.Encoding = String.Encoding.utf8) throws -> String {
        
        let absoluteFilePath = Bundle.main.path(forResource: fileName, ofType: fileType)
        
        if let absoluteFilePath = absoluteFilePath {
            
            if let fileData = try? Data.init(contentsOf: URL(fileURLWithPath: absoluteFilePath)) {
                
                if let fileAsString = NSString(data: fileData, encoding: encoding.rawValue) {
                    return fileAsString as String
                } else {
                    print("readFileFromResources failed on: \(fileName). Failed to convert data to String!")
                    throw ReadFileFromResourcesError.failedToConvertData
                }
                
            } else {
                print("readFileFromResources failed on: \(fileName). Failed to load any data!")
                throw ReadFileFromResourcesError.failedToLoadData
            }
        }
        
        print("readFileFromResources failed on: \(fileName). File does not exist!")
        throw ReadFileFromResourcesError.fileDoesNotExist
    }
    
    func loadJSONData() {
        
        do {
            let jsonString = try readFileFromResources("social_activity", fileType: ".json")
            
            let jsonData: Data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            do {
                
                let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
                
                let socialActivities = dictionary.value(forKey: "socialActivity") as! NSArray
                
                for socialActivity in socialActivities {
                    
                    let type = (socialActivity as AnyObject).value(forKey: "type") as! String
                    let shares = (socialActivity as AnyObject).value(forKey: "shares") as! Int
                    let desc = (socialActivity as AnyObject).value(forKey: "desc") as! String
                    
                    print("type = \(type), shares = \(shares), desc = \(desc)")
                    
                    socialPosts.append(SocialPost(type: type, shares: shares, desc: desc))
                }
                
            } catch {
                print("json error: \(error)")
            }
            
        } catch {
            print("read error: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return socialPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "socialTableViewCell", for: indexPath) as! SocialTableViewCell
        
        cell.sharesText.text = String(socialPosts[indexPath.row].shares)
        cell.descText.text = socialPosts[indexPath.row].desc
        cell.socialIcon.image = UIImage(named: socialPosts[indexPath.row].type)
        
        return cell
    }
}

