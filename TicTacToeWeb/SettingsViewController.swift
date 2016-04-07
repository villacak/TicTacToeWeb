//
//  SettingsViewController.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/28/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var newUserBtn: UIButton!
    @IBOutlet weak var resetUserBtn: UIButton!
    @IBOutlet weak var resetScoresBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var reachability: Reachability!
    
    // Create the shared context
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    
    //
    // Load data when view has been loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.stopAnimating()
        self.title = Constants.SETTINGS_TITLE
        
        userName.delegate = self
        initialSettings()
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
                                                         selector: #selector(SettingsViewController.reachabilityChanged(_:)),
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
            self.userName.enabled = true
            self.newUserBtn.enabled = true
            Settings.updateShownDialog(false)
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                if Settings.getShownDialog() == false {
                    Dialog().okDismissAlert(titleStr: Constants.INTERNET_TITLE, messageStr: Constants.NO_INTERNET_CONN, controller: self)
                    Settings.updateShownDialog(true)
                }
                self.userName.enabled = false
                self.newUserBtn.enabled = false
            })
            print("Not reachable")
        }
    }

    
    //
    // Reset Scores
    //
    func resetScores() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
        do {
            let fetchRequest = NSFetchRequest(entityName: Scores.Keys.ScoresClass)
            fetchRequest.returnsObjectsAsFaults = false
            let tempScores: [Scores] = try sharedContext.executeFetchRequest(fetchRequest) as! [Scores]
            if (tempScores.count > 0) {
                let result: Scores = tempScores[0]
                result.draws = 0
                result.loses = 0
                result.wins = 0
                CoreDataStackManager.sharedInstance().saveContext()
            }
        } catch let error as NSError {
            Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: error.localizedDescription, controller: self)
            print("Error : \(error.localizedDescription)")
        }
    }
    
    
    //
    // Initial settings for settings view
    //
    func initialSettings() {
        if let tempUserName: String = Settings.getUser() {
            if (tempUserName != Constants.EMPTY_STRING) {
                userName.text = tempUserName
                userName.enabled = false
                newUserBtn.enabled = false
                resetUserBtn.enabled = true
                resetScoresBtn.enabled = true
            } else {
                setButtonsIfNoExistingUser()
            }
        } else {
            setButtonsIfNoExistingUser()
        }
    }
    
    
    //
    // Create or retrieve user action
    //
    @IBAction func newUserAction(sender: AnyObject) {
        view.endEditing(true)
        if let tempUserName = userName.text where ((userName.text?.isEmpty) != nil) {
            if (tempUserName != Constants.EMPTY_STRING) {
                spinner.startAnimating()
                callUpdateUser(tempUserName as String)
            } else {
                Dialog().okDismissAlert(titleStr: Constants.USER_ERROR, messageStr: Constants.USER_EMPTY, controller: self)
            }
        } else {
            Dialog().okDismissAlert(titleStr: Constants.USER_ERROR, messageStr: Constants.USER_EMPTY, controller: self)
        }
    }
    
    
    //
    // Reset User action
    //
    @IBAction func resetUserAction(sender: AnyObject) {
        Settings.updateUser(Constants.EMPTY_STRING)
        userName.enabled = true
        userName.becomeFirstResponder()
        resetScores()
        initialSettings()
    }
    
    
    //
    // Reset Scores action
    //
    @IBAction func resetScoresAction(sender: AnyObject) {
        resetScores()
        initialSettings()
    }
    
    
    //
    // Give the right time to dismiss the view
    //
    func dismissTheViewDueNointernet() {
        Dialog().okDismissAlert(titleStr: Constants.USER_ERROR, messageStr: Constants.USER_EMPTY, controller: self)
        let delay = 1.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
    }
    
    
    
    //
    // Delegate to dismiss the keyboard
    //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //
    // Prepare buttons
    //
    func setButtonsIfNoExistingUser() {
        newUserBtn.enabled = true
        resetUserBtn.enabled = false
        resetScoresBtn.enabled = true
    }
    
    
    //
    // Create the new user, retrieve it if the name already exist
    //
    func callUpdateUser(name: String) {
        let trimName = name.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let jsonUtils: JSONUtils = JSONUtils()
        jsonUtils.callRequestForUserServices(name: trimName, method: Constants.PUT_METHOD, service: Constants.USER_CREATE_SERVICE, controller: self, completionHandler: { (result, errorString) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if let errorMessage = errorString  {
                    
                    Dialog().okDismissAlert(titleStr: Constants.ERROR_TITLE, messageStr: errorMessage, controller: self)
                    self.userName.becomeFirstResponder()
                    
                } else {
                    
                    if (trimName == result?.userName) {
                        Dialog().okDismissAlert(titleStr: Constants.SUCCESS_TITLE, messageStr: Constants.SUCESS_CREATED_USER, controller: self)
                        Settings.updateUser(trimName)
                        if let tempIdUser = result?.iduser {
                            Settings.updateIdUser(tempIdUser)
                        }
                    } else {
                        Dialog().okDismissAlert(titleStr: Constants.SUCCESS_TITLE, messageStr: Constants.FAIL_CREATE_USER, controller: self)
                    }
                    
                }
                self.initialSettings()
                self.spinner.stopAnimating()
            })
        })
    }
    
}
