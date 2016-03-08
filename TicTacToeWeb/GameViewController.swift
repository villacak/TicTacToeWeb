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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerText: UILabel!
    
    var imgPos1: UIImageView!
    var imgPos2: UIImageView!
    var imgPos3: UIImageView!
    var imgPos4: UIImageView!
    var imgPos5: UIImageView!
    var imgPos6: UIImageView!
    var imgPos7: UIImageView!
    var imgPos8: UIImageView!
    var imgPos9: UIImageView!
    
    
    
    // This value will come from the REST response.
    var playerSelection: String!
    
    // This one check if you has last played
    var lastPlayed: Bool = false
    
    // This one will load all button that have been already selected
    var buttonTouched: [Bool] = [ true, false, false, false, false, false, false, false, false, false ]
    
    // For keep calling the services in time intervals
    var poolingForCheck: NSTimer!
    
    // To know the position selected bu the user
    var playerPosition: String!
    
    // Error counter to invalidate the pooling
    var errorCounter: Int = 0
    
    //
    // Load settings when view did load
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.GAME_TITLE
        hideSpinner()
        
        // check if exist a game or create a new
        clearGames()
//        createOrGetGame()
        
        
        // Do any additional setup after loading the view.
    }

    
    //
    // when user tap in a position
    //
    @IBAction func UIButtonClicked(sender: UIButton) {
        if !buttonTouched[sender.tag] {
            buttonTouched[sender.tag] = true
            lastPlayed = true
            playerPosition = "\(sender.tag)"
            setImageForSpot(sender.tag, played: lastPlayed, selection: playerSelection)
            prepareForTheOtherUserPlay()
        }
    
    }

  
    //
    // Set image in the button
    //
    func setImageForSpot(spot: Int, played: Bool, selection: String) {
        let playerMark = (selection == Constants.X) ? Constants.X_IMAGE : Constants.O_IMAGE
        let image: UIImage = UIImage(named: playerMark)!

        switch spot {
        case 1:
            pos1.setImage(image, forState: UIControlState.Normal)
            
        case 2:
            pos2.setImage(image, forState: UIControlState.Normal)
            
        case 3:
            pos3.setImage(image, forState: UIControlState.Normal)
            
        case 4:
            pos4.setImage(image, forState: UIControlState.Normal)
            
        case 5:
            pos5.setImage(image, forState: UIControlState.Normal)
            
        case 6:
            pos6.setImage(image, forState: UIControlState.Normal)
            
        case 7:
            pos7.setImage(image, forState: UIControlState.Normal)
            
        case 8:
            pos8.setImage(image, forState: UIControlState.Normal)
            
        case 9:
            pos9.setImage(image, forState: UIControlState.Normal)
            
        default:
            pos5.setImage(image, forState: UIControlState.Normal)
            
        }
    }

    
    //
    // Hide spinner
    //
    func hideSpinner() {
        spinner.stopAnimating()
        spinnerText.hidden = true
        
    }
    

    //
    // Prepare for check if the other player has played
    //
    func prepareForTheOtherUserPlay() {
        spinner.startAnimating()
        spinnerText.hidden = false
        disableBoard()
        poolingForCheck = NSTimer.scheduledTimerWithTimeInterval(Constants.POOLING_TIME, target: self, selector: Selector(Constants.CHECK_OTHER_PLAYER), userInfo: nil, repeats: true)
    }
    
    
    //
    // Call the check game service
    //
    func poolingCheck() {
        let jsonUtils: JSONUtils = JSONUtils()
        jsonUtils.callRequestForPlayOrCheckGameService(game: "\(Settings.getGame())", selection: Settings.getSelection(), position: playerPosition, method: Constants.PUT_METHOD, service: Constants.GAME_PLAY, controller: self, completionHandler: { (result, errorString) -> Void in
            self.hideSpinner()
            self.enableBoard()
            if let errorMessage = errorString  {
                self.errorCounter++
                Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: errorMessage, controller: self)
                if self.errorCounter > 3 {
                    self.poolingForCheck.invalidate()
                    self.errorCounter = 0
                    self.dismissTheView()
                }
            } else {
                self.poolingForCheck.invalidate()
                self.errorCounter = 0
                self.chekResponse(result!)
            }
            self.poolingForCheck.invalidate()
            self.hideSpinner()
        })
    }
    
    
    //
    // Clear all games from the actual user
    //
    func clearGames() {
        let jsonUtils: JSONUtils = JSONUtils()
        jsonUtils.callRequestForFinalizeGameService(name: Settings.getUser(), method: Constants.GET_METHOD, service: Constants.GAME_FINALIZE_SERVICE, controller: self, completionHandler: { (result, errorString) -> Void in
            if let errorMessage = errorString  {
                Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: errorMessage, controller: self)
                self.dismissTheView()
            } else {
                self.createOrGetGame()
            }
        })
    }
    
    
    //
    // Call the create game or get a game with one person on hold.
    //
    func createOrGetGame() {
        let jsonUtils: JSONUtils = JSONUtils()
        jsonUtils.callRequestForCreateGameService(name: Settings.getUser(), method: Constants.PUT_METHOD, service: Constants.GAME_CREATE_SERVICE, controller: self, completionHandler: { (result, errorString) -> Void in
            if let errorMessage = errorString  {
                Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: errorMessage, controller: self)
                self.dismissTheView()
            } else {
                let game: Game = result!;
                Settings.updateGame(game.game!)
                Settings.updateSelection(game.playerXOrO!)
                Dialog().okDismissAlert(titleStr: Constants.INFORMATION, messageStr: "X always start.\n You are \(Settings.getSelection())", controller: self)
                self.playerSelection = Settings.getSelection()
            }
        })
    }
    
    
    
    //
    // Give the right time to dismiss the view
    //
    func dismissTheView() {
        let delay = 1.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
    }
    
    
    //
    // Disable board
    //
    func disableBoard() {
        pos1.enabled = false;
        pos2.enabled = false;
        pos3.enabled = false;
        pos4.enabled = false;
        pos5.enabled = false;
        pos6.enabled = false;
        pos7.enabled = false;
        pos8.enabled = false;
        pos9.enabled = false;
    }
    
    
    //
    // Enable board
    //
    func enableBoard() {
        pos1.enabled = true;
        pos2.enabled = true;
        pos3.enabled = true;
        pos4.enabled = true;
        pos5.enabled = true;
        pos6.enabled = true;
        pos7.enabled = true;
        pos8.enabled = true;
        pos9.enabled = true;
    }
    
    
    //
    // Check response
    //
    func chekResponse(result: Game) {
        
    }
}
