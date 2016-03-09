//
//  UrlHelper.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 2/13/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import UIKit

class UrlHelper: NSObject {

    
    //
    // Encode the Dictionary Strings for URL using query parameters
    //
    func encodeParameters(params params: [String: String]) -> String {
        let queryItems = params.map { NSURLQueryItem(name:$0, value:$1)}
        let components = NSURLComponents()
        components.queryItems = queryItems
        return components.percentEncodedQuery ?? Constants.EMPTY_STRING
    }
    
    
    //
    // Return User URLs for services
    //
    func populateServicesWithUserName(userName userName: String!, service: String!) -> String {
        var urlToReturn: String!
        if service == Constants.USER_CREATE_SERVICE {
            urlToReturn = "\(Constants.URL_BASE)\(Constants.USER_CREATE)\(userName)"
        } else if service == Constants.USER_RETRIEVE_SERVICE {
            urlToReturn = "\(Constants.URL_BASE)\(Constants.USER_RETRIEVE)\(userName)"
        } else if service == Constants.USER_DELETE_SERVICE {
            urlToReturn = "\(Constants.URL_BASE)\(Constants.USER_DELETE)\(userName)"
        } else if service == Constants.GAME_CREATE_SERVICE {
            urlToReturn = "\(Constants.URL_BASE)\(Constants.GAME_CREATE)\(userName)"
        }
        return urlToReturn
    }
    
    
    //
    // Return Games URLs for play andcheck services
    //
    func populateGamePlayOrCheck(game game: String, selection: String, position: String, service: String) -> String {
        var urlToReturn: String!
        let params: [String: String] = ["game" : game, "selection" : selection, "position" : position]
        let encodedParams: String = encodeParameters(params: params)
        if service == Constants.GAME_PLAY_SERVICE {
            urlToReturn = "\(Constants.URL_BASE)\(Constants.GAME_PLAY)\(encodedParams)"
        } else if service == Constants.GAME_CHECK_SERVICE {
            urlToReturn = "\(Constants.URL_BASE)\(Constants.GAME_CHECK)\(encodedParams)"
        }
        return urlToReturn
    }
    
    
    //
    // Populate Games finalize url service
    //
    func populateGameFinalize(userName userName: String) -> String {
        let params: [String: String] = ["name" : userName]
        let encodedParams: String = encodeParameters(params: params)
        let urlToReturn: String = "\(Constants.URL_BASE)\(Constants.GAME_FINALIZE)\(encodedParams)"
        return urlToReturn
    }
    
}
