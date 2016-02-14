//
//  Games.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/13/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import Foundation


struct Game {
    
    var user: User?
    var plays: [Play]?
    var idgames: Int?
    var game: Int?
    var playerXOrO: String?
    var wonXOrY: String?
    var playersNumber: Int?

    
    init() {
        self.user = User()
        self.plays = [Play]()
        self.idgames = 0
        self.game = 0
        self.playerXOrO = ""
        self.wonXOrY = ""
        self.playersNumber = 0
    }
    
    init(user: User, plays: [Play], idgames: Int, game: Int, playerXOrO: String, wonXOrY: String, playersNumber: Int) {
        self.user = user
        self.plays = plays
        self.idgames = idgames
        self.game = game
        self.playerXOrO = playerXOrO
        self.wonXOrY = wonXOrY
        self.playersNumber = playersNumber
    }
    
}
