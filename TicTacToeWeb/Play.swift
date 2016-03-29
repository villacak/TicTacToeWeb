//
//  Play.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/13/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import Foundation

struct Play {
    
    var game: Int?
    var playid: Int?
    var position: Int?
    var userId: Int?
    
    init() {
        self.game = 0
        self.playid = 0
        self.position = 0
        self.userId = 0
    }
    
    init(game: Int, playid: Int, position: Int, userId: Int) {
        self.game = game
        self.playid = playid
        self.position = position
        self.userId = userId
    }
    
}

