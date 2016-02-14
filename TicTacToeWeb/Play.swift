//
//  Play.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/13/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import Foundation

struct Play {
    
    var game: Game?
    var playid: Int?
    var position: Int?
    
    init() {
        self.game = Game()
        self.playid = 0
        self.position = 0
    }
    
    init(game: Game, playid: Int, position: Int) {
        self.game = game
        self.playid = playid
        self.position = position
    }
    
}

