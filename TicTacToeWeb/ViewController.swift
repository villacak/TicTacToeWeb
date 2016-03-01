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
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initialChecks()   
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
    }
}

