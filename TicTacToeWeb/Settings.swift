//
//  Settings.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/28/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    
    static let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    
    
    //
    // Check if exist already some data in the NSUSerDefaults
    //
    static func checkIfNSUserDefaultsHasBeenCreated() -> Bool {
        return defaults.objectForKey(Constants.USER_NAME) != nil
    }
    
    
    //
    // Set defaults
    //
    static func initialDefaults() {
        defaults.setObject(Constants.EMPTY_STRING, forKey: Constants.USER_NAME)
        defaults.setInteger(0, forKey: Constants.WINS)
        defaults.setInteger(0, forKey: Constants.LOSES)
        defaults.setInteger(0, forKey: Constants.DRAWS)
        defaults.setObject(Constants.EMPTY_STRING, forKey: Constants.LAST_DATE_PLAYED)
        defaults.setInteger(0, forKey: Constants.GAME)
    }
   
    
    //
    // Reset defaults
    //
    static func resetDefaults() {
        defaults.setInteger(0, forKey: Constants.WINS)
        defaults.setInteger(0, forKey: Constants.LOSES)
        defaults.setInteger(0, forKey: Constants.DRAWS)
        defaults.setObject(Constants.EMPTY_STRING, forKey: Constants.LAST_DATE_PLAYED)
        defaults.setInteger(0, forKey: Constants.GAME)
    }

    
    //
    // User get and set
    //
    static func updateUser(name: String) {
        defaults.setObject(name, forKey: Constants.USER_NAME)
    }
    
    static func getUser() -> String {
        var userName: String = Constants.EMPTY_STRING
        if let tempName: String = defaults.stringForKey(Constants.USER_NAME) {
            userName = tempName
        }
        return userName
    }
    
    
    //
    // Wins get and set
    //
    static func updateWins() {
        let wins: Int = getWins() + 1
        defaults.setInteger(wins, forKey: Constants.WINS)
    }
    
    static func getWins() -> Int {
        var wins: Int = 0
        if let tempWins: Int = defaults.integerForKey(Constants.WINS) {
            wins = tempWins
        }
        return wins
    }
    
    static func resetWins() {
        defaults.setInteger(0, forKey: Constants.WINS)
    }
    
    
    //
    // Loses get and set
    //
    static func updateLoses() {
        let loses: Int = getLoses() + 1
        defaults.setInteger(loses, forKey: Constants.LOSES)
    }
    
    static func getLoses() -> Int {
        var loses: Int = 0
        if let tempLoses: Int = defaults.integerForKey(Constants.LOSES) {
            loses = tempLoses
        }
        return loses
    }
    
    static func resetLoses() {
        defaults.setInteger(0, forKey: Constants.LOSES)
    }

    
    //
    // Draws get and set
    //
    static func updateDraws() {
        let draws: Int = getDraws() + 1
        defaults.setInteger(draws, forKey: Constants.DRAWS)
    }
    
    static func getDraws() -> Int {
        var draws: Int = 0
        if let tempDraws: Int = defaults.integerForKey(Constants.DRAWS) {
            draws = tempDraws
        }
        return draws
    }
    
    static func resetDraws() {
        defaults.setInteger(0, forKey: Constants.DRAWS)
    }

    
    //
    // Last Date Played get and set
    //
    static func updateLastDatePlayed(date: String) {
        defaults.setObject(date, forKey: Constants.LAST_DATE_PLAYED)
    }
    
    static func getLastDatePlayed() -> String {
        var date: String = Constants.EMPTY_STRING
        if let tempDate: String = defaults.stringForKey(Constants.LAST_DATE_PLAYED) {
            date = tempDate
        }
        return date
    }
    
    
    //
    // Games get and set
    //
    static func updateGame(game: Int) {
        defaults.setInteger(game, forKey: Constants.GAME)
    }
    
    static func getGame() -> Int {
        var game: Int = 0
        if let tempGame: Int = defaults.integerForKey(Constants.GAME) {
            game = tempGame
        }
        return game
    }

    
    //
    // Selection get and set
    //
    static func updateSelection(selection: String) {
        defaults.setObject(selection, forKey: Constants.SELECTION)
    }
    
    static func getSelection() -> String {
        var selection: String = Constants.EMPTY_STRING
        if let tempSelection: String = defaults.stringForKey(Constants.SELECTION) {
            selection = tempSelection
        }
        return selection
    }

}
