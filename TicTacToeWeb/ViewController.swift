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
    
    var reachability: Reachability!
    let ReachabilityChangedNotificationStart: String = "ReachabilityChangedNotificationStart"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //
    // View will Appear
    //
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initialChecks()   
    }
    
    
    //
    // Run after view did appear
    //
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ViewController.reachabilityChanged(_:)),
                                                         name: ReachabilityChangedNotification,
                                                         object: reachability)
                
        do {
            try reachability.startNotifier()
        } catch {
            print("This is not working.")
            return
        }
    }
    
    //
    // View will disppear
    //
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    
    //
    // Connection has changed
    //
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            initialChecks() 
            Settings.updateShownDialog(false)
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                if Settings.getShownDialog() == false {
                    Dialog().okDismissAlert(titleStr: Constants.INTERNET_TITLE, messageStr: Constants.NO_INTERNET_CONN, controller: self)
                    Settings.updateShownDialog(true)
                }
                self.playBtn.enabled = false
                self.settingsBtn.enabled = false
            })
            print("Not reachable")
        }
    }

    
    
    //
    // Initial checks for the app
    //
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
        settingsBtn.enabled = true
    }
}

