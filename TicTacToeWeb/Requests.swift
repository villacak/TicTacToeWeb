//
//  Requests.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/13/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import Foundation
import UIKit

class Requests: NSObject {
    
    //
    // Generic Request
    //
    func request(urlToCall urlToCall: String, method: String, controller: UIViewController, completionHandler:(result: NSDictionary!, error: String?) -> Void) -> NSURLSessionDataTask  {
        let url: NSURL = NSURL(string: urlToCall)!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    if data.length > 0 {
                        let jsonResult: NSDictionary? = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        // Add the check for error form here, if no result or result
                        if let tempErrorMessage: NSArray = jsonResult![Constants.ERROR_TO_RETURN] as? NSArray {
                            let statusMessage = self.prepareErrorMessage(tempErrorMessage[0] as? String)
                            completionHandler(result: nil, error: "\(statusMessage.firstItem)\n\(statusMessage.secondItem)")
                        } else if let _: Dictionary<String, AnyObject> = jsonResult![Constants.SUCCESS_NO_DATA] as? Dictionary<String, AnyObject> {
                            completionHandler(result: jsonResult, error: nil)
                        } else {
                            completionHandler(result: jsonResult, error: nil)
                        }
                    } else {
                        completionHandler(result: [Constants.EMPTY_STRING: Constants.EMPTY_STRING], error: nil)
                    }
                } catch let error as NSError {
                    completionHandler(result: nil, error: error.localizedDescription)
                    print("Error 1: \(error.localizedDescription)")
                }
            } else if let error = error {
                completionHandler(result: nil, error: error.localizedDescription)
                print("Error 2: \(error.localizedDescription)")
            }
        })
        task.resume()
        return task
    }
    
    
    //
    // Prepate error message
    //
    func prepareErrorMessage(message: String!) -> (firstItem: String, secondItem: String) {
        var msg: String = message
        msg = msg.stringByReplacingOccurrencesOfString("\"", withString: Constants.EMPTY_STRING)
        msg = msg.stringByReplacingOccurrencesOfString("{", withString: Constants.EMPTY_STRING)
        msg = msg.stringByReplacingOccurrencesOfString("}", withString: Constants.EMPTY_STRING)
        msg = msg.stringByReplacingOccurrencesOfString(" ", withString: Constants.EMPTY_STRING)
        
        let splitString = msg.characters.split{$0 == ","}.map{String($0)}
        let firstItem: String = splitString[0].stringByReplacingOccurrencesOfString(":", withString: " ")
        let secondItem: String = splitString[1].stringByReplacingOccurrencesOfString(":", withString: " ")
        return (firstItem, secondItem)
    }
}
