//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/24/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
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
    var buttonTouched: [String] = [ Constants.TRUE, Constants.FALSE, Constants.FALSE, Constants.FALSE, Constants.FALSE, Constants.FALSE, Constants.FALSE, Constants.FALSE, Constants.FALSE, Constants.FALSE ]
    
    // For keep calling the services in time intervals
    var poolingForCheck: NSTimer!
    
    // To know the position selected bu the user
    var playerPosition: String!
    
    // Error counter to invalidate the pooling
    var errorCounter: Int = 0
    
    var trysCounter: Int = 0
    
    var reachability: Reachability!
    
    var winsVar: Int = 0
    var losesVar: Int = 0
    var drawsVar: Int = 0
    
    let reusableId: String = "ScoresInfo"
    var editingScores: Bool = false
    
    
    // Create the shared context
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    //
    // Load settings when view did load
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.GAME_TITLE
        self.disableBoard()
        hideSpinner()
        
        // clear all previous games form this user and check if exist a game to enroll or create a new
        clearGames(false)
        poulateValues()
    }
    
    
    //
    // Populate the Pin array from the DB
    //
    func poulateValues() {
        do {
            let fetchRequest = NSFetchRequest(entityName: Scores.Keys.ScoresClass)
            fetchRequest.returnsObjectsAsFaults = false
            let tempScores: [Scores] = try sharedContext.executeFetchRequest(fetchRequest) as! [Scores]
            if (tempScores.count > 0) {
                let result: Scores = tempScores[0]
                winsVar = result.wins as Int
                losesVar = result.loses as Int
                drawsVar = result.draws as Int
            }
        } catch let error as NSError {
            Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: error.localizedDescription, controller: self)
            print("Error : \(error.localizedDescription)")
        }
    }
    
    
    
    //
    // View will appear, set the notification center
    //
    override func viewWillAppear(animated: Bool) {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(GameViewController.reachabilityChangedGame(_:)),
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
        do {
            let fetchRequest = NSFetchRequest(entityName: Scores.Keys.ScoresClass)
            fetchRequest.returnsObjectsAsFaults = false
            let tempScores: [Scores] = try sharedContext.executeFetchRequest(fetchRequest) as! [Scores]
            if (tempScores.count > 0) {
                let result: Scores = tempScores[0]
                result.draws = drawsVar
                result.loses = losesVar
                result.wins = winsVar
                CoreDataStackManager.sharedInstance().saveContext()
            }
        } catch let error as NSError {
            Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: error.localizedDescription, controller: self)
            print("Error : \(error.localizedDescription)")
        }
    }
    
    
    
    //
    // Connection has changed
    //
    func reachabilityChangedGame(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                if Settings.getShownDialog() == false {
                    Dialog().okDismissAlert(titleStr: Constants.INTERNET_TITLE, messageStr: Constants.NO_INTERNET_CONN, controller: self)
                    Settings.updateShownDialog(true)
                }
                self.disableBoard()
                self.hideSpinner()
                self.dismissTheView()
            })
            print("Not reachable")
        }
    }
    
    
    //
    // Call clearGames when the user leave the view
    //
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            clearGames(true);
        }
    }
    
    
    //
    // when user tap in a position
    //
    @IBAction func UIButtonClicked(sender: UIButton) {
        if buttonTouched[sender.tag] == Constants.FALSE {
            lastPlayed = true
            playerPosition = "\(sender.tag)"
            if playerPosition == nil {
                playerPosition = Constants.EMPTY_STRING
            }
            if playerSelection == nil {
                playerSelection = Constants.EMPTY_STRING
            }
            setImageForSpot(sender.tag, played: lastPlayed, selection: playerSelection)
            setPlay()
            prepareForTheOtherUserPlay()
            checkIfThisUserWon(Settings.getSelection())
        }
    }
    
    
    //
    // Set image in the button
    //
    func setImageForSpot(spot: Int, played: Bool, selection: String) {
        let playerMark = (selection == Constants.X) ? Constants.X_IMAGE : Constants.O_IMAGE
        let image: UIImage = UIImage(named: playerMark)!
        buttonTouched[spot] = playerMark
        
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
        poolingForCheck?.invalidate()
        poolingForCheck = NSTimer.scheduledTimerWithTimeInterval(Constants.POOLING_TIME,
                                                                 target: self,
                                                                 selector: Selector(Constants.CHECK_OTHER_PLAYER),
                                                                 userInfo: nil,
                                                                 repeats: true)
    }
    
    
    //
    // Persist the play into the server
    //
    func setPlay() {
        let jsonUtils: JSONUtils = JSONUtils()
        jsonUtils.callRequestForPlayOrCheckGameService(game: "\(Settings.getGame())", selection: Settings.getSelection(), position: playerPosition, method: Constants.PUT_METHOD, service: Constants.GAME_PLAY_SERVICE, controller: self, completionHandler: { (result, errorString) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if let errorMessage = errorString  {
                    if (errorMessage.rangeOfString(Constants.OFFLINE) == nil) {
                        self.errorTryCounter(errorMessage)
                    }
                } else {
                    self.errorCounter = 0
                    if self.trysCounter == Constants.MAX_NUMBER_OF_POOLING_CALLS {
                        Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: Constants.MAX_TRY_REACHED, controller: self)
                        self.dismissTheView()
                    }
                }
            })
        })
    }
    
    
    //
    // Call the check game service
    //
    func poolingCheck() {
        let jsonUtils: JSONUtils = JSONUtils()
        jsonUtils.callRequestForCheckGameService(game: "\(Settings.getGame())", method: Constants.GET_METHOD, service: Constants.GAME_CHECK_SERVICE, controller: self, completionHandler: { (result, errorString) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if let errorMessage = errorString  {
                    if (errorMessage.rangeOfString(Constants.OFFLINE) == nil) {
                        self.errorTryCounter(errorMessage)
                    }
                } else {
                    self.errorCounter = 0
                    if self.trysCounter <= Constants.MAX_NUMBER_OF_POOLING_CALLS {
                        if let _ = result?.game?.plays {
                            self.chekResponse(result!)
                        }
                    } else {
                        Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: Constants.MAX_TRY_REACHED, controller: self)
                        self.poolingForCheck.invalidate()
                        self.dismissTheView()
                    }
                }
            })
        })
    }
    
    
    //
    // Error tried counter
    //
    func errorTryCounter(errorMessage: String) {
        self.errorCounter += 1
        Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: errorMessage + "\n It will retry \(3 - self.errorCounter) time(s)", controller: self)
        if self.errorCounter > Constants.MAX_FAIL_ATTEMPTS { // the service can fail for 3 times before we cancel
            self.poolingForCheck.invalidate()
            self.errorCounter = 0
            self.dismissTheView()
        }
    }
    
    
    //
    // Clear all games from the actual user
    //
    func clearGames(isJustClean: Bool) {
        spinner.startAnimating()
        let jsonUtils: JSONUtils = JSONUtils()
        jsonUtils.callRequestForFinalizeGameService(name: Settings.getUser(), method: Constants.GET_METHOD, service: Constants.GAME_FINALIZE_SERVICE, controller: self, completionHandler: { (result, errorString) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if let errorMessage = errorString  {
                    if (errorMessage.rangeOfString(Constants.OFFLINE) == nil) {
                        Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: errorMessage, controller: self)
                        self.dismissTheView()
                    }
                } else {
                    if !isJustClean {
                        self.createOrGetGame()
                    }
                }
            })
        })
    }
    
    
    //
    // Call the create game or get a game with one person on hold.
    //
    func createOrGetGame() {
        let jsonUtils: JSONUtils = JSONUtils()
        jsonUtils.callRequestForCreateGameService(name: Settings.getUser(), method: Constants.PUT_METHOD, service: Constants.GAME_CREATE_SERVICE, controller: self, completionHandler: { (result, errorString) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if let errorMessage = errorString  {
                    if (errorMessage.rangeOfString(Constants.OFFLINE) == nil) {
                        Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: errorMessage, controller: self)
                        self.dismissTheView()
                    }
                } else {
                    self.spinner.stopAnimating()
                    let game: Game = result!;
                    Settings.updateGame(game.game!)
                    Settings.updateSelection(game.playerXOrO!)
                    self.playerSelection = Settings.getSelection()
                    self.actionsForWhoStartAndDontStart(Settings.getSelection())
                }
            })
        })
    }
    
    
    //
    // Dialogs for X or O
    // X will start playing, O will wait for the other make a play
    //
    func actionsForWhoStartAndDontStart(selection: String) {
        if selection == Constants.X {
            Dialog().okDismissAlert(titleStr: Constants.INFORMATION, messageStr: Constants.START_PLAYING, controller: self)
            self.enableBoard()
        } else {
            Dialog().okDismissAlert(titleStr: Constants.INFORMATION, messageStr: Constants.WAIT_FOR_USER_PLAY, controller: self)
            prepareForTheOtherUserPlay()
        }
    }
    
    
    //
    // Give the right time to dismiss the view
    //
    func dismissTheView() {
        let delay = 2.5 * Double(NSEC_PER_SEC)
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
    // Check if the device user has won
    //
    func checkIfThisUserWon(roundSelection: String) {
        let playerSelection: String = (roundSelection == Constants.X) ? Constants.X_IMAGE : Constants.O_IMAGE
        if (buttonTouched[1] == playerSelection && buttonTouched[2] == playerSelection && buttonTouched[3] == playerSelection ||
            buttonTouched[4] == playerSelection && buttonTouched[5] == playerSelection && buttonTouched[6] == playerSelection ||
            buttonTouched[7] == playerSelection && buttonTouched[8] == playerSelection && buttonTouched[9] == playerSelection ||
            buttonTouched[1] == playerSelection && buttonTouched[4] == playerSelection && buttonTouched[7] == playerSelection ||
            buttonTouched[2] == playerSelection && buttonTouched[5] == playerSelection && buttonTouched[8] == playerSelection ||
            buttonTouched[3] == playerSelection && buttonTouched[6] == playerSelection && buttonTouched[9] == playerSelection ||
            buttonTouched[1] == playerSelection && buttonTouched[5] == playerSelection && buttonTouched[9] == playerSelection ||
            buttonTouched[3] == playerSelection && buttonTouched[5] == playerSelection && buttonTouched[7] == playerSelection) {
            
            if roundSelection == Settings.getSelection() {
                Dialog().okDismissAlert(titleStr: Constants.WINNER_TITLE, messageStr: Constants.WINNER_TEXT, controller: self)
                winsVar = winsVar + 1
            } else if roundSelection != Settings.getSelection() {
                Dialog().okDismissAlert(titleStr: Constants.LOSER_TITLE, messageStr: Constants.LOSER_TEXT, controller: self)
                losesVar = losesVar + 1
            }
            disableBoard()
            hideSpinner()
        }
    }
    
    
    //
    // Check response
    //
    func chekResponse(gameChecked: CheckGame) {
        let gameForCheck: Game = gameChecked.game!
        
        if ((gameChecked.playNumber != nil || gameChecked.playNumber > 0) &&
            (gameForCheck.playerXOrO != nil &&
                gameForCheck.playerXOrO != Constants.EMPTY_STRING &&
                gameForCheck.playerXOrO != Settings.getSelection())) {
            // The check has to check for the other player play not the device player
            if (gameForCheck.playerXOrO != Settings.getSelection()) {
                let lastPlace: Int = (gameForCheck.plays?.count)!
                if lastPlace > 0 {
                    let lastPlay: Play = gameForCheck.plays![lastPlace - 1]
                    if buttonTouched[lastPlay.position!] == Constants.X_IMAGE ||
                        buttonTouched[lastPlay.position!] == Constants.O_IMAGE {
                        trysCounter += 1
                    } else {
                        setImageForSpot(lastPlay.position!, played: false, selection: gameForCheck.playerXOrO!)
                        self.hideSpinner()
                        self.enableBoard()
                        self.poolingForCheck.invalidate()
                        checkIfThisUserWon(gameForCheck.playerXOrO!)
                    }
                }
            }
            
            if (gameChecked.winner == false && gameForCheck.plays?.count == Constants.MAX_NUMBER_OF_PLAY) {
                // Draw game
                drawsVar = drawsVar + 1
                disableBoard()
                hideSpinner()
                Dialog().okDismissAlert(titleStr: Constants.DRAW_TITLE, messageStr: Constants.DRAW_TEXT, controller: self)
            }
        } else {
            if (trysCounter <= Constants.MAX_NUMBER_OF_POOLING_CALLS) {
                trysCounter += 1
            } else {
                trysCounter = 0
                poolingForCheck?.invalidate()
                Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: Constants.MAX_TRY_REACHED, controller: self)
                dismissTheView()
            }
        }
    }
}
