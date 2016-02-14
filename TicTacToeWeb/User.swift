//
//  User.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/13/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import Foundation


struct User {
    
    var iduser: Int?
    var userName: String?
    var statsWins: Int?
    var statsLoses: Int?
    var statsTied: Int?
    var lastDatePlayed: String?
    var games: [Game]?
    
    init() {
        self.iduser = 0
        self.userName = ""
        self.statsWins = 0
        self.statsLoses = 0
        self.statsTied = 0
        self.lastDatePlayed = ""
        self.games = [Game]()
    }
    
    init(iduser: Int, userName: String, statsWins: Int, statsLoses: Int, statsTied: Int, lastDatePlayed: String, games: [Game]) {
        self.iduser = iduser
        self.userName = userName
        self.statsWins = statsWins
        self.statsLoses = statsLoses
        self.statsTied = statsTied
        self.lastDatePlayed = lastDatePlayed
        self.games = games
    }
    
}
