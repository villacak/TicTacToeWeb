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
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var loses: UILabel!
    @IBOutlet weak var draws: UILabel!
    @IBOutlet weak var lastPlayedDate: UILabel!
    
    //
    // Load stats when the view is loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.STATS_TITLE
        
        userName.text = Settings.getUser()
        wins.text = "\(Settings.getWins())"
        loses.text = "\(Settings.getLoses())"
        draws.text = "\(Settings.getDraws())"
        lastPlayedDate.text = Settings.getLastDatePlayed()
    }

    
}
