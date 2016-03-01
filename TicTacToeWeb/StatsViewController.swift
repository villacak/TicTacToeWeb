//
//  StatsViewController.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/29/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    
    @IBOutlet weak var userName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.STATS_TITLE
        
        userName.text = Settings.getUser()

        // Do any additional setup after loading the view.
    }

    
}
