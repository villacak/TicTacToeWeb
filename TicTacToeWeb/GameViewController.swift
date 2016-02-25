//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/24/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var pos1: UIButton!
    @IBOutlet weak var pos2: UIButton!
    @IBOutlet weak var pos3: UIButton!
    @IBOutlet weak var pos4: UIButton!
    @IBOutlet weak var pos5: UIButton!
    @IBOutlet weak var pos6: UIButton!
    @IBOutlet weak var pos7: UIButton!
    @IBOutlet weak var pos8: UIButton!
    @IBOutlet weak var pos9: UIButton!
    
    
    // This value will come from the REST response.
    var playerSelection: String = Constants.X
    
    // This one check if you has last played
    var lastPlayed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButtonLabels()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func UIButtonClicked(sender: UIButton) {

    
    }

    
    
    func resetButtonLabels() {
        pos1.setTitle("", forState: UIControlState.Normal)
        pos2.setTitle("", forState: UIControlState.Normal)
        pos3.setTitle("", forState: UIControlState.Normal)
        pos4.setTitle("", forState: UIControlState.Normal)
        pos5.setTitle("", forState: UIControlState.Normal)
        pos6.setTitle("", forState: UIControlState.Normal)
        pos7.setTitle("", forState: UIControlState.Normal)
        pos8.setTitle("", forState: UIControlState.Normal)
        pos9.setTitle("", forState: UIControlState.Normal)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
