//
//  Constants.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/13/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import Foundation


class Constants: NSObject {

    // Base URL
//    static let URL_BASE: String = "http://ec2-52-26-42-218.us-west-2.compute.amazonaws.com:8080"
    static let URL_BASE: String = "http://localhost:8080/server/rest"
    
    
    // Endpoints
    // Game Services
    static let GAME_CREATE: String = "/game/v1/create/"
    static let GAME_PLAY: String = "/game/v1/play?"
    static let GAME_CHECK: String = "/game/v1/check?"
    static let GAME_FINALIZE: String = "/game/v1/finalize?"
    
    // User Services
    static let USER_CREATE: String = "/user/v1/create/"
    static let USER_RETRIEVE: String = "/user/v1/retrieve/"
    static let USER_DELETE: String = "/user/v1/delete/"
    
    // User Services
    static let USER_CREATE_SERVICE: String = "userCreate"
    static let USER_RETRIEVE_SERVICE: String = "userRetrieve"
    static let USER_DELETE_SERVICE: String = "userDelete"
    
    // Games Services
    static let GAME_CREATE_SERVICE: String = "gameCreate"
    static let GAME_PLAY_SERVICE: String = "gamePlay"
    static let GAME_CHECK_SERVICE: String = "gameCheck"
    static let GAME_FINALIZE_SERVICE: String = "gameFinalize"

    
    // REST Call Methods
    static let GET_METHOD: String = "GET"
    static let POST_METHOD: String = "POST"
    static let PUT_METHOD: String = "PUT"
    static let DELETE_METHOD: String = "DELETE"
    
    
    // Empty String
    static let EMPTY_STRING: String = ""
    
    // User
    static let ID_USER: String =  "iduser"
    static let USER_NAME: String = "userName"
    static let STATS_WINS: String = "statsWins"
    static let STATS_LOSES: String = "statsLoses"
    static let STATS_TIED: String = "statsTied"
    static let LAST_DATE_PLAYED: String = "lastDatePlayed"
    static let GAMES: String = "games"
    
    // Game
    static let USER: String = "user"
    static let PLAYS: String = "plays"
    static let ID_GAMES: String = "idgames"
    static let GAME: String = "game"
    static let PLAYER_X_OR_O: String = "playerXOrO"
    static let WON_X_OR_Y: String = "wonXOrY"
    static let PLAYERS_NUMBER: String = "playersNumber"
    
    // Play
    static let PLAY_ID: String = "playid"
    static let POSITON: String = "position"
    
    // Options
    static let SELECTION: String = "selection"
    static let X: String = "x"
    static let X_IMAGE: String = "x_image"
    static let O: String = "o"
    static let O_IMAGE: String = "o_image"
    
    
    // Settings
    static let WINS: String = "wins"
    static let LOSES: String = "loses"
    static let DRAWS: String = "draws"
    
    // Function name for pooling
    static let CHECK_OTHER_PLAYER: String = "poolingCheck"

    // Dialog titles and messages
    static let SUCCESS_TITLE: String = "Success"
    static let ERROR_TITLE: String = "Response Error"
    static let GAME_TITLE: String = "Game"
    static let STATS_TITLE: String = "Stats"
    static let SETTINGS_TITLE: String = "Settings"    
    static let SUCESS_CREATED_USER: String = "Success created new user"

    static let POOLING_TIME: NSTimeInterval = 4.0
}