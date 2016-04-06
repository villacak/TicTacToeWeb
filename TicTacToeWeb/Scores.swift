//
//  Scores.swift
//  TicTacToe
//
//  Created by Klaus Villaca on 4/5/16.
//  Copyright © 2016 Klaus Villaca. All rights reserved.
//

import Foundation
import CoreData

@objc(Scores)
class Scores: NSManagedObject {
    
    struct Keys {
        static let ScoresClass = "Scores"
        static let wins: String = "wins"
        static let loses: String = "loses"
        static let draws: String = "draws"
    }
    
    @NSManaged var wins: NSNumber
    @NSManaged var loses: NSNumber
    @NSManaged var draws: NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(valueWin: Int, valueLose: Int, valueDraw: Int, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName(Keys.ScoresClass, inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        wins = valueWin
        loses = valueLose
        draws = valueDraw
    }
}