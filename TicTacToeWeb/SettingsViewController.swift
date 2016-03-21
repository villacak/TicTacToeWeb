//
//  SettingsViewController.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/28/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var newUserBtn: UIButton!
    @IBOutlet weak var resetUserBtn: UIButton!
    @IBOutlet weak var resetScoresBtn: UIButton!
    
    
    //
    // Load data when view has been loaded
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.SETTINGS_TITLE
        
        userName.delegate = self
        initialSettings()
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
    // Reset Scores
    //
    func resetScores() {
        Settings.resetWins()
        Settings.resetLoses()
        Settings.resetDraws()
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
            })
        })
    }
    
    
}
