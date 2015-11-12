//
//  Obstacle.swift
//  DonaldTheTower
//
//  Created by Oi I Chan on 11/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

//MainScene class will implement (some of) the CCPhysicsCollisionDelegate protocol methods
class Obstacle : CCNode {
    weak var topCarrot : CCNode!
    weak var bottomCarrot : CCNode!
    
    //carrot at the top reaches at least 30 points into the screen for a 3.5-inch iPhone
    let topCarrotMinimumPositionY : CGFloat = 128
    //carrot always sticks at least 30 points out of the ground
    let bottomCarrotMaximumPositionY : CGFloat = 440
    //describes how large the opening gap between the carrots should be.
    let carrotDistance : CGFloat = 142
    
    func didLoadFromCCB() {
        //This changes the carrot's physics bodies to sensors. Setting the sensor value to true tells Chipmunk no actual collision feedback should be calculated, meaning the collision callback method does run but sensors will always allow the colliding objects to pass through the collision.
        topCarrot.physicsBody.sensor = true
        bottomCarrot.physicsBody.sensor = true
    }
    
    func setupRandomPosition() {
        // returns a value between 0.f and 1.f
        let randomPrecision : UInt32 = 100
        let random = CGFloat(arc4random_uniform(randomPrecision)) / CGFloat(randomPrecision)
        let range = bottomCarrotMaximumPositionY - carrotDistance - topCarrotMinimumPositionY
        topCarrot.position = ccp(topCarrot.position.x,topCarrotMinimumPositionY + (random * range));
        bottomCarrot.position = ccp(bottomCarrot.position.x, topCarrot.position.y + carrotDistance);
    }
    

}
