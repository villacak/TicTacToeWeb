//
//  CheckGame.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 3/21/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

struct CheckGame {
    
    var playNumber: Int?
    var game: Game?
    var winner: Bool?
    
    init() {
        self.playNumber = 0
        self.game = Game()
        self.winner = false
    }
    
    init(playNumber: Int, game: Game, winner: Bool) {
        self.playNumber = playNumber
        self.game = game
        self.winner = winner
    }
}
