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
                    let user: User = self.parseDictionaryToUser(responseAsNSDictinory, loadRelationship: true)
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
                    let game: Game = self.parseDictionaryToGame(responseAsNSDictinory, loadRelationship: true)
                    completionHandler(result: game, errorString: nil)
                }
            } else {
                // If success returns nil then it's necessary display an alert to the user
                completionHandler(result: nil, errorString: errorString)
            }
        })
    }
    
    
    //
    // Call games services Play and Check and return the JSON parsed
    //
    func callRequestForPlayOrCheckGameService(game game: String, selection: String, position: String, method: String, service: String, controller: UIViewController, completionHandler:(result: Game?, errorString: String?) -> Void) {
        
        let urlHelper: UrlHelper = UrlHelper()
        let urlUserCreate: String = urlHelper.populateGamePlayOrCheck(game: game, selection: selection, position: position, service: service)
        let request: Requests = Requests()
        
        var responseAsNSDictinory: Dictionary<String, AnyObject>!
        request.request(urlToCall: urlUserCreate, method: method , controller: controller, completionHandler: { (result, errorString) -> Void in
            if (result != nil) {
                responseAsNSDictinory = (result as NSDictionary) as! Dictionary<String, AnyObject>
                if let errorMessage = errorString  {
                    completionHandler(result: nil, errorString: errorMessage)
                } else {
                    let game: Game = self.parseDictionaryToGame(responseAsNSDictinory, loadRelationship: true)
                    completionHandler(result: game, errorString: nil)
                }
            } else {
                // If success returns nil then it's necessary display an alert to the user
                completionHandler(result: nil, errorString: errorString)
            }
        })
    }
    
    
    //
    // Call games services Check and return the JSON parsed
    //
    func callRequestForCheckGameService(game game: String, method: String, service: String, controller: UIViewController, completionHandler:(result: CheckGame?, errorString: String?) -> Void) {
        
        let urlHelper: UrlHelper = UrlHelper()
        let urlUserCreate: String = urlHelper.populateGamePlayOrCheck(game: game, selection:
            Constants.EMPTY_STRING, position: Constants.EMPTY_STRING, service: service)
        let request: Requests = Requests()
        
        var responseAsNSDictinory: Dictionary<String, AnyObject>!
        request.request(urlToCall: urlUserCreate, method: method , controller: controller, completionHandler: { (result, errorString) -> Void in
            if (result != nil) {
                responseAsNSDictinory = (result as NSDictionary) as! Dictionary<String, AnyObject>
                dispatch_async(dispatch_get_main_queue(), {
                    if let errorMessage = errorString  {
                        completionHandler(result: nil, errorString: errorMessage)
                    } else {
                        let checkGame: CheckGame = self.parseDictionaryToCheckGame(responseAsNSDictinory)
                        completionHandler(result: checkGame, errorString: nil)
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    // If success returns nil then it's necessary display an alert to the user
                    completionHandler(result: nil, errorString: errorString)
                })
            }
        })
    }
    
    
    
    //
    // Call games service Finalize and return the JSON parsed
    //
    func callRequestForFinalizeGameService(name name: String, method: String, service: String, controller: UIViewController, completionHandler:(result: Game?, errorString: String?) -> Void) {
        
        let urlHelper: UrlHelper = UrlHelper()
        let urlUserCreate: String = urlHelper.populateGameFinalize(userName: name)
        let request: Requests = Requests()
        
        var responseAsNSDictinory: Dictionary<String, AnyObject>!
        request.request(urlToCall: urlUserCreate, method: method , controller: controller, completionHandler: { (result, errorString) -> Void in
            if (result != nil) {
                responseAsNSDictinory = (result as NSDictionary) as! Dictionary<String, AnyObject>
                if let errorMessage = errorString  {
                    completionHandler(result: nil, errorString: errorMessage)
                } else {
                    let game: Game = self.parseDictionaryToGame(responseAsNSDictinory, loadRelationship: true)
                    completionHandler(result: game, errorString: nil)
                }
            } else {
                // If success returns nil then it's necessary display an alert to the user
                completionHandler(result: nil, errorString: errorString)
            }
        })
    }
    
    
    
    
    //
    // Parse from Dictionary to User
    //
    func parseDictionaryToUser(dictionaryResponse: Dictionary<String, AnyObject>, loadRelationship: Bool) -> User {
        var user: User = User()
        user.iduser = dictionaryResponse[Constants.ID_USER] as? Int
        user.userName = dictionaryResponse[Constants.USER_NAME] as? String
        user.statsWins = dictionaryResponse[Constants.STATS_WINS] as? Int
        user.statsLoses = dictionaryResponse[Constants.STATS_LOSES] as? Int
        user.statsTied = dictionaryResponse[Constants.STATS_TIED] as? Int
        user.lastDatePlayed = dictionaryResponse[Constants.LAST_DATE_PLAYED] as? String
        
        if (loadRelationship) {
            if let tempGameDictionary: Dictionary<String, AnyObject> = dictionaryResponse[Constants.GAMES] as? Dictionary<String, AnyObject> {
                let gamesCounter: Int = tempGameDictionary.count
                if gamesCounter > 0 {
                    var games: [Game] = [Game]()
                    for (key, value) in tempGameDictionary {
                        let singleItemDictionary: Dictionary<String, AnyObject> = [key : value]
                        let game: Game = parseDictionaryToGame(singleItemDictionary, loadRelationship: false)
                        if let tempGame: Game = game {
                            games.append(tempGame)
                        }
                    }
                    user.games = games
                }
            }
        } else {
            user.games = nil
        }
        return user
    }
    
    
    //
    // Parse from Dictinary to Game
    //
    func parseDictionaryToGame(dictionaryResponse: Dictionary<String, AnyObject>, loadRelationship: Bool) -> Game {
        var game: Game = Game()
        if (loadRelationship) {
            if let tempUser: Dictionary<String, AnyObject> = dictionaryResponse[Constants.USER] as? Dictionary<String, AnyObject> {
                game.user = parseDictionaryToUser(tempUser, loadRelationship: loadRelationship)
            }
//            if let playsDic: Dictionary<String, AnyObject> = dictionaryResponse[Constants.PLAYS] as? Dictionary<String, AnyObject> {
//                game.plays = getPlays(playsDic)
//            }
        } else {
            game.plays = nil
            game.user = nil
        }
        
        
        game.idgames = dictionaryResponse[Constants.ID_GAMES] as? Int
        game.game = dictionaryResponse[Constants.GAME] as? Int
        game.playerXOrO = dictionaryResponse[Constants.PLAYER_X_OR_O] as? String
        game.wonXOrY = dictionaryResponse[Constants.WON_X_OR_Y] as? String
        game.playersNumber = dictionaryResponse[Constants.PLAYERS_NUMBER] as? Int
        return game
    }
    
    
    //
    // Parse for game, with first level relationship
    //
    func parseDictionaryToGameRelationshipFirstLevel(dictionaryResponse: Dictionary<String, AnyObject>) -> Game {
        var game: Game = Game()
        if let tempUser: Dictionary<String, AnyObject> = dictionaryResponse[Constants.USER] as? Dictionary<String, AnyObject> {
            game.user = parseDictionaryToUser(tempUser, loadRelationship: false)
        }
        if let playsDic: NSArray = dictionaryResponse[Constants.PLAYS] as? NSArray {
            game.plays = getPlays(playsDic)
        }
        game.idgames = dictionaryResponse[Constants.ID_GAMES] as? Int
        game.game = dictionaryResponse[Constants.GAME] as? Int
        game.playerXOrO = dictionaryResponse[Constants.PLAYER_X_OR_O] as? String
        game.wonXOrY = dictionaryResponse[Constants.WON_X_OR_Y] as? String
        game.playersNumber = dictionaryResponse[Constants.PLAYERS_NUMBER] as? Int
        return game
    }
    
    
    
    
    //
    // Loop through all play dictorany and return an array
    //
    func getPlays(arrayResponse: NSArray) -> [Play] {
        var playsToReturn: [Play] = [Play]()
        for play in arrayResponse {
            let singleItemDictionary: Dictionary<String, AnyObject> = (play as? Dictionary<String, AnyObject>)!
            let play: Play = parseDictionaryToPlay(singleItemDictionary)
            if let tempPlay: Play = play {
                playsToReturn.append(tempPlay)
            }
        }
        return playsToReturn
    }
    
    
    //
    // Parse from Dictionary to Play
    //
    func parseDictionaryToPlay(dictionaryResponse: Dictionary<String, AnyObject>) -> Play {
        var play: Play = Play()
        play.playid = dictionaryResponse[Constants.PLAY_ID] as? Int
        play.game = dictionaryResponse[Constants.GAME] as? Int
        play.position = dictionaryResponse[Constants.POSITON] as? Int
        play.userId = dictionaryResponse[Constants.USER_ID] as? Int
        return play
    }
    
    
    //
    // Parse from Dictionary to CheckGame
    //
    func parseDictionaryToCheckGame(dictionaryResponse: Dictionary<String, AnyObject>) -> CheckGame {
        var checkGame: CheckGame = CheckGame()
        checkGame.playNumber = dictionaryResponse[Constants.PLAY_NUMBER] as? Int
        if let tempGame: Dictionary<String, AnyObject> = dictionaryResponse[Constants.GAMES_ENTITY] as? Dictionary<String, AnyObject> {
            checkGame.game = parseDictionaryToGameRelationshipFirstLevel(tempGame)
        }
        checkGame.winner = dictionaryResponse[Constants.WINNER] as? Bool
        return checkGame
    }
    
}
