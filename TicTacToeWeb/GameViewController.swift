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
    
    // This one will load all button that have been already selected
    var buttonTouched: [Bool] = [ true, false, false, false, false, false, false, false, false, false ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButtonLabels()
        

        // Do any additional setup after loading the view.
    }

    
    @IBAction func UIButtonClicked(sender: UIButton) {
        print(sender.tag)
        if !buttonTouched[sender.tag] {
            buttonTouched[sender.tag] = true
            lastPlayed = true
            setImageForSpot(sender.tag + 1, played: lastPlayed)
        }
    
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
    
    
    func setImageForSpot(spot: Int, played: Bool) {
        let playerMark = (played) ? Constants.X_IMAGE : Constants.O_IMAGE

        switch spot {
        case 1:
            pos1.imageView?.image = UIImage(named: playerMark)
            
        case 2:
            pos2.imageView?.image = UIImage(named: playerMark)
            
        case 3:
            pos3.imageView?.image = UIImage(named: playerMark)
            
        case 4:
            pos4.imageView?.image = UIImage(named: playerMark)
            
        case 5:
            pos5.imageView?.image = UIImage(named: playerMark)
            
        case 6:
            pos6.imageView?.image = UIImage(named: playerMark)
            
        case 7:
            pos7.imageView?.image = UIImage(named: playerMark)
            
        case 8:
            pos8.imageView?.image = UIImage(named: playerMark)
            
        case 9:
            pos9.imageView?.image = UIImage(named: playerMark)
            
        default:
            pos5.imageView?.image = UIImage(named: playerMark)
            
        }
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
