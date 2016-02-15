//
//  JSONUtils.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/14/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class JSONUtils: NSObject {
    
    //
    // Call user services and return the JSON parsed
    //
    func callRequestForUserServices(name name: String, method: String, service: String, controller: UIViewController, completionHandler:(result: User?, errorString: String?) -> Void) {
        
        let urlHelper: UrlHelper = UrlHelper()
        let urlUserCreate: String = urlHelper.populateServicesWithUserName(userName: name, service: service)
        let request: Requests = Requests()
        
        var responseAsNSDictinory: Dictionary<String, AnyObject>!
        request.request(urlToCall: urlUserCreate, method: method , controller: controller, completionHandler: { (result, errorString) -> Void in
            if (result != nil) {
                responseAsNSDictinory = (result as NSDictionary) as! Dictionary<String, AnyObject>
                if let errorMessage = errorString  {
                    completionHandler(result: nil, errorString: errorMessage)
                } else {
                    var user: User = User()
                    user.iduser = responseAsNSDictinory[Constants.ID_USER] as? Int
                    user.userName = responseAsNSDictinory[Constants.USER_NAME] as? String
                    user.statsWins = responseAsNSDictinory[Constants.STATS_WINS] as? Int
                    user.statsLoses = responseAsNSDictinory[Constants.STATS_LOSES] as? Int
                    user.statsTied = responseAsNSDictinory[Constants.STATS_TIED] as? Int
                    user.lastDatePlayed = responseAsNSDictinory[Constants.LAST_DATE_PLAYED] as? String
                    user.games = responseAsNSDictinory[Constants.GAMES] as? [Game]
                    
                    completionHandler(result: user, errorString: nil)
                }
            } else {
                // If success returns nil then it's necessary display an alert to the user
                completionHandler(result: nil, errorString: errorString)
            }
        })
    }
    
    
    //
    // Call games services and return the JSON parsed
    //
    func callRequestForCreateGameService(name name: String, method: String, service: String, controller: UIViewController, completionHandler:(result: Game?, errorString: String?) -> Void) {
        
        let urlHelper: UrlHelper = UrlHelper()
        let urlUserCreate: String = urlHelper.populateServicesWithUserName(userName: name, service: service)
        let request: Requests = Requests()
        
        var responseAsNSDictinory: Dictionary<String, AnyObject>!
        request.request(urlToCall: urlUserCreate, method: method , controller: controller, completionHandler: { (result, errorString) -> Void in
            if (result != nil) {
                responseAsNSDictinory = (result as NSDictionary) as! Dictionary<String, AnyObject>
                if let errorMessage = errorString  {
                    completionHandler(result: nil, errorString: errorMessage)
                } else {
                    var game: Game = Game()
                    game.user = responseAsNSDictinory[Constants.USER] as? User
                    game.plays = responseAsNSDictinory[Constants.PLAYS] as? [Play]
                    game.idgames = responseAsNSDictinory[Constants.ID_GAMES] as? Int
                    game.game = responseAsNSDictinory[Constants.GAME] as? Int
                    game.playerXOrO = responseAsNSDictinory[Constants.PLAYER_X_OR_O] as? String
                    game.wonXOrY = responseAsNSDictinory[Constants.WON_X_OR_Y] as? String
                    game.playersNumber = responseAsNSDictinory[Constants.PLAYERS_NUMBER] as? Int
                    
                    completionHandler(result: game, errorString: nil)
                }
            } else {
                // If success returns nil then it's necessary display an alert to the user
                completionHandler(result: nil, errorString: errorString)
            }
        })
    }
    
    
}
