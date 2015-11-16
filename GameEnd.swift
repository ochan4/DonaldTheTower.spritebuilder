//
//  GameEnd.swift
//  DonaldTheTower
//
//  Created by Oi I Chan on 11/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import GameKit


class GameEnd : CCNode {
    weak var currentScoreLabel: CCLabelTTF!
    weak var bestScoreLabel: CCLabelTTF!
    var bestScore: NSInteger!
    var currentScore: NSInteger!
    
    func didLoadFromCCB() {
        setUpGameCenter()
        
        //变量
        currentScore = GameStateSingleton.sharedInstance.lastscore
        
        //显示出数字
        currentScoreLabel.string = String(GameStateSingleton.sharedInstance.lastscore)
        checkForHighScore()
        bestScoreLabel.string = String(GameStateSingleton.sharedInstance.highestscore)
        
        println(currentScore)
        println(bestScore)
    }
    
    //check high score
    func checkForHighScore() {
        var highscore = GameStateSingleton.sharedInstance.highestscore
        if currentScore > highscore || currentScore == highscore{
            GameStateSingleton.sharedInstance.highestscore = currentScore
            GameCenterInteractor.sharedInstance.reportHighScoreToGameCenter()
            bestScore = currentScore
        } else {
            bestScore = highscore
        }
    }
    
    //a function that authenticates your user
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
    }
    
    //load the mainscene again
    func newGame() {
        var mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
    
    //load the leaderboard scene
    func leaderBoard() {
        showLeaderboard()
    }
}

// MARK: Game Center Handling
extension GameEnd: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}