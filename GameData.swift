//
//  GameData.swift
//  DonaldTheTower
//
//  Created by Oi I Chan on 11/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameStateSingleton: NSObject {
    
    var lastscore:Int = NSUserDefaults.standardUserDefaults().integerForKey("currentscore") {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(lastscore, forKey:"currentscore")
        }
    }
    
    var highestscore:Int = NSUserDefaults.standardUserDefaults().integerForKey("highscore") {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(highestscore, forKey:"highscore")
        }
    }
    
    class var sharedInstance : GameStateSingleton {
        struct Static {
            static let instance : GameStateSingleton = GameStateSingleton()
        }
        return Static.instance
    }
    
//    func checkHighScore () {
//        if lastscore > highestscore {
//            NSUserDefaults.standardUserDefaults().setObject(lastscore, forKey: "highscore")
//            GameCenterInteractor.sharedInstance.reportHighScoreToGameCenter()
//        }
//    }
}