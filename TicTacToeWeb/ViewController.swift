//
//  ViewController.swift
//  TicTacToeWeb
//
//  Created by Klaus Villaca on 2/9/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var scoresBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialChecks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initialChecks() {
        if !Settings.checkIfNSUserDefaultsHasBeenCreated() {
            Settings.initialDefaults()
        }
        
        if Settings.getUser() != Constants.EMPTY_STRING {
            playBtn.enabled = true
            scoresBtn.enabled = true
        } else {
            playBtn.enabled = false
            scoresBtn.enabled = false
        }
    }
    
    
    
    func callServiceTest() {
        let jsonUtils: JSONUtils = JSONUtils()
        var userTemp: User!
        jsonUtils.callRequestForUserServices(name: "Klaus7", method: Constants.PUT_METHOD, service: Constants.USER_CREATE, controller: self, completionHandler: { (result, errorString) -> Void in
            if let errorMessage = errorString  {
                print(errorMessage)
            } else {
                userTemp = result
                print(userTemp)
            }
        })
    }
    
}

