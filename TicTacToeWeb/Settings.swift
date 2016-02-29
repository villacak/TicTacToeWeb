//
//  Settings.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/28/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    //
    // Set defaults
    //
    func initialDefaults() {
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
    func resetDefaults() {
        defaults.setInteger(0, forKey: Constants.WINS)
        defaults.setInteger(0, forKey: Constants.LOSES)
        defaults.setInteger(0, forKey: Constants.DRAWS)
        defaults.setObject(Constants.EMPTY_STRING, forKey: Constants.LAST_DATE_PLAYED)
        defaults.setInteger(0, forKey: Constants.GAME)
    }

    
    //
    // User get and set
    //
    func updateUser(name: String) {
        defaults.setObject(name, forKey: Constants.USER_NAME)
    }
    
    func getUser() -> String {
        var userName: String = Constants.EMPTY_STRING
        if let tempName: String = defaults.stringForKey(Constants.USER_NAME) {
            userName = tempName
        }
        return userName
    }
    
    
    //
    // Wins get and set
    //
    func updateWins() {
        let wins: Int = getWins() + 1
        defaults.setInteger(wins, forKey: Constants.WINS)
    }
    
    func getWins() -> Int {
        var wins: Int = 0
        if let tempWins: Int = defaults.integerForKey(Constants.WINS) {
            wins = tempWins
        }
        return wins
    }
    
    
    //
    // Loses get and set
    //
    func updateLoses() {
        let loses: Int = getLoses() + 1
        defaults.setInteger(loses, forKey: Constants.LOSES)
    }
    
    func getLoses() -> Int {
        var loses: Int = 0
        if let tempLoses: Int = defaults.integerForKey(Constants.LOSES) {
            loses = tempLoses
        }
        return loses
    }

    
    //
    // Draws get and set
    //
    func updateDraws() {
        let draws: Int = getDraws() + 1
        defaults.setInteger(draws, forKey: Constants.DRAWS)
    }
    
    func getDraws() -> Int {
        var draws: Int = 0
        if let tempDraws: Int = defaults.integerForKey(Constants.DRAWS) {
            draws = tempDraws
        }
        return draws
    }

    
    //
    // Last Date Played get and set
    //
    func updateLastDatePlayed(date: String) {
        defaults.setObject(date, forKey: Constants.LAST_DATE_PLAYED)
    }
    
    func getLastDatePlayed() -> String {
        var date: String = Constants.EMPTY_STRING
        if let tempDate: String = defaults.stringForKey(Constants.LAST_DATE_PLAYED) {
            date = tempDate
        }
        return date
    }
    
    
    //
    // Games get and set
    //
    func updateGame(game: Int) {
        defaults.setInteger(game, forKey: Constants.GAME)
    }
    
    func getGame() -> Int {
        var game: Int = 0
        if let tempGame: Int = defaults.integerForKey(Constants.GAME) {
            game = tempGame
        }
        return game
    }

}
