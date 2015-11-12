//
//  Goal.swift
//  DonaldTheTower
//
//  Created by Oi I Chan on 11/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Goal: CCNode {
    func didLoadFromCCB() {
        physicsBody.sensor = true;
    }
}