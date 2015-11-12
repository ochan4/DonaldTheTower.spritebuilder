//
//  GameEnd.swift
//  DonaldTheTower
//
//  Created by Oi I Chan on 11/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameEnd : CCNode {
    //load the mainscene again
    func newGame() {
        var mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
}