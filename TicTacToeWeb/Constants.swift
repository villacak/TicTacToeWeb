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
    static let URL_BASE: String = "http://ec2-52-26-42-218.us-west-2.compute.amazonaws.com:8080"

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

    
    // REST Call Methods
    static let GET_METHOD = "GET"
    static let POST_METHOD = "POST"
    static let PUT_METHOD = "PUT"
    static let DELETE_METHOD = "DELETE"
    
    
    // Empty String
    static let EMPTY_STRING: String = ""
}