//
//  StatsViewController.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/29/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController, NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var loses: UILabel!
    @IBOutlet weak var draws: UILabel!
    @IBOutlet weak var lastPlayedDate: UILabel!
    
    
    // Create the shared context
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    
    //
    // Load stats when the view is loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Always fresh data
        do {
            let fetchRequest = NSFetchRequest(entityName: Scores.Keys.ScoresClass)
            fetchRequest.returnsObjectsAsFaults = false
            let tempScores: [Scores] = try sharedContext.executeFetchRequest(fetchRequest) as! [Scores]
            if (tempScores.count > 0) {
                let result: Scores = tempScores[0] as Scores
                draws.text = "\(result.draws)"
                loses.text = "\(result.loses)"
                wins.text = "\(result.wins)"
            } else {
                draws.text = "0"
                loses.text = "0"
                wins.text = "0"
                let _: Scores = Scores(valueWin: 0, valueLose: 0, valueDraw: 0, context: sharedContext)
                CoreDataStackManager.sharedInstance().saveContext()
            }
        } catch let error as NSError {
            Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: error.localizedDescription, controller: self)
            print("Error : \(error.localizedDescription)")
        }

        
        self.title = Constants.STATS_TITLE
        
        userName.text = Settings.getUser()
        lastPlayedDate.text = Settings.getLastDatePlayed()
    }
}
