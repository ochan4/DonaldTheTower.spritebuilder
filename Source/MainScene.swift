import Foundation
import GameKit

//declare that the MainScene class will implement (some of) the CCPhysicsCollisionDelegate protocol methods
class MainScene : CCNode, CCPhysicsCollisionDelegate {
    var scrollSpeed: CGFloat = 220
    
    weak var hero: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
    
    weak var ground1: CCSprite!
    weak var ground2: CCSprite!
    var grounds: [CCSprite] = []  // initializes an empty array
    
    var sinceTouch: CCTime = 0
    
    var obstacles: [CCNode] = []
    var firstObstaclePosition: CGFloat! = 280
    var firstDelayObstaclePoistion: CGFloat!
    let distanceBetweenObstacles: CGFloat = 275
    
    weak var obstaclesLayer: CCNode!
    
    //weak var restartButton: CCButton!
    var isGameOver = false
    
    weak var playButton:CCButton!
    weak var gameBeginLayer:CCNodeColor!
    var isGameBegin = true
    
    var points: NSInteger = 0
    weak var scoreLabel: CCLabelTTF!
    weak var billionLabel: CCLabelTTF!
    weak var getReadyLabel: CCLabelTTF!
        

//*********************************************Functions**************************************************//
    //This method is called every time a CCB file is loaded
    func didLoadFromCCB() {
        
        gamePhysicsNode.collisionDelegate = self
        
        grounds.append(ground1)
        grounds.append(ground2)
    }
    
    override func update(delta: CCTime) {
        //first obstacle position should be 200 pixel away from the hero
        firstDelayObstaclePoistion = (hero.position.x + 200)
       
        // scroll speed of your bunny while updating the positions of movable objects.
        //By multiplying the scroll speed with delta time you ensure that the bunny always moves at the same speed, independent of the frame rate.
        hero.position = ccp(hero.position.x + scrollSpeed * CGFloat(delta), hero.position.y)
        gamePhysicsNode.position = ccp(gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta), gamePhysicsNode.position.y)
        
        
        //cancled the black line effect due to a change speed on HERO
        // clamp physics node and hero position to the next nearest pixel value to avoid black line artifacts
//        let scale = CCDirector.sharedDirector().contentScaleFactor
//        hero.position = ccp(round(hero.position.x * scale) / scale, round(hero.position.y * scale) / scale)
//        gamePhysicsNode.position = ccp(round(gamePhysicsNode.position.x * scale) / scale, round(gamePhysicsNode.position.y * scale) / scale)
        
        // loop the ground whenever a ground image was moved entirely outside the screen
        // perform a check for each ground sprite to see if it has moved off the screen, and if so, it will be moved to the far right and next to the ground sprite that's currently still visible on the screen.
        for ground in grounds {
            // get the world position of the ground
            let groundWorldPosition = gamePhysicsNode.convertToWorldSpace(ground.position)
            // get the screen position of the ground
            let groundScreenPosition = convertToNodeSpace(groundWorldPosition)
            // if the left corner is one complete width off the screen, move it to the right
            if groundScreenPosition.x <= (-ground.contentSize.width) {
                ground.position = ccp(ground.position.x + ground.contentSize.width * 2, ground.position.y)
            }
        }
        
        // clamp velocity
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), 200)
        hero.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        
        //limit the rotation of the bunny and start a downward rotation if no touch occurred in a while
        //First, you add the delta (change in) time to the sinceTouch value to capture how much time has passed since the last touch.
        sinceTouch += delta
        
        //In the next line, we limit the rotation of the bunny.
        //$Clamping: means testing and optionally changing a given value so that it never exceeds the specified value range.
        hero.rotation = clampf(hero.rotation, -10, 40)
        
        //Next, you check if the bunny allows rotation because later, you will disable rotation upon death. If rotation is allowed, you clamp the angular velocity to slow down the rotation if it exceeds the value range. Then you apply that new angular velocity.
        if (hero.physicsBody.allowsRotation) {
            let angularVelocity = clampf(Float(hero.physicsBody.angularVelocity), -2, 1)
            hero.physicsBody.angularVelocity = CGFloat(angularVelocity)
        }
        //Finally, you check if more than three tenths of a second passed since the last touch. If that is the case, a strong downward rotation impulse is applied. rotate downwards if enough time passed since last touch
        if (sinceTouch > 0.3 && isGameBegin == false) {
            let impulse = -18000.0 * delta
            hero.physicsBody.applyAngularImpulse(CGFloat(impulse))
        }
        
        // checking for removable obstacles
        for obstacle in obstacles.reverse() {
            let obstacleWorldPosition = gamePhysicsNode.convertToWorldSpace(obstacle.position)
            let obstacleScreenPosition = convertToNodeSpace(obstacleWorldPosition)
            
            // obstacle moved past left side of screen?
            if obstacleScreenPosition.x < (-obstacle.contentSize.width-100) {
                obstacle.removeFromParent()
                obstacles.removeAtIndex(find(obstacles, obstacle)!)
                
                // for each removed obstacle, add a new one
                spawnNewObstacle()
            }
        }
    }//END OF UPDATE METHOD
    
    //applies an impulse to the bunny every time a touch is first detected:
    //$override: the idea of inheritance - that is, a child class inherits methods and properties from its parent class.
    //#MainScene.swift is a child of CCNode, which is indicated by the line MainScene: CCNode. CCNode has a touchBegan(...) method, so we must use the override keyword to indicate that our child class will override its parent's implementation of touchBegan(...).
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (isGameOver == false) {
            // move up and rotate
            hero.physicsBody.applyImpulse(ccp(0, 400))
            hero.physicsBody.applyAngularImpulse(10000)
            sinceTouch = 0
        }
    }
    
    func spawnNewObstacle() {
        //If no other obstacles already exist the position of the first obstacle will be set to the firstObstaclePosition constant you just defined.
        var prevObstaclePos = firstObstaclePosition
        if obstacles.count == 0 {
            prevObstaclePos = firstDelayObstaclePoistion
        }
        
        if obstacles.count > 0 {
            prevObstaclePos = obstacles.last!.position.x
        }
        
        // create and add a new obstacle by loading it from the Obstacle.ccb file
        //declare the value returned and assigned to the obstacle constant as being of class Obstacle
        let obstacle = CCBReader.load("Obstacle") as! Obstacle
        //and places it within the defined distance of the last existing obstacle.
        obstacle.position = ccp(prevObstaclePos + distanceBetweenObstacles, 0)
        //calling the setupRandomPosition method after assigning the initial position.
        obstacle.setupRandomPosition()
        obstaclesLayer.addChild(obstacle)
        obstacles.append(obstacle)

    }
    
    //The method will be called whenever a object with collision type hero collides with an object of collision type level.
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero nodeA: CCNode!, goal: CCNode!) -> ObjCBool {
        goal.removeFromParent()
        points++
        scoreLabel.string = String(points)
        return true
    }
    
    //implement a collision handler method. As parameter names you have to use the collision types level and hero that you defined earlier.
    //The method above will be called whenever a object with collision type hero collides with an object of collision type level.
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, level: CCNode!) -> ObjCBool {
        gameOver()
        return true
    }
    
    func playGame(){
        //基本
        playButton.visible = false
        getReadyLabel.visible = false       //tutorial mode invisble
        isGameBegin = false
        
        userInteractionEnabled = true

        // 按了才能开始 spawn the first obstacles
        for i in 1...3 {
            spawnNewObstacle()
        }
        
        // 按了重力才开始往下牵引
        gamePhysicsNode.gravity = ccp(0,-700)
    }
    
    func gameOver() {
        if (isGameOver == false) {
            isGameOver = true
            
            //*****save score to send to GameEnd file or other files******************
            GameStateSingleton.sharedInstance.lastscore = points

            var gameEndPopover = CCBReader.load("GameEnd") as! GameEnd
            gameEndPopover.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
            gameEndPopover.position = ccp(0.5, 0.5)
            gameEndPopover.zOrder = Int.max
            addChild(gameEndPopover)
            
            //limit background action
            scrollSpeed = 0
            hero.rotation = 90
            hero.physicsBody.allowsRotation = false
            
            // just in case
            hero.stopAllActions()
            
            var move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            var moveBack = CCActionEaseBounceOut(action: move.reverse())
            var shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
            
            //disable the score in game end mode
            scoreLabel.visible = false
            billionLabel.visible = false
        }
    }
}



    //1. Change the gravitational constant of the universe
    //2. Making code connections
    //3. Adding touch input #didload from ccb, touch began
    //4. Adding a speed limit upward #override update
    //5. Make the bunny Rotate #On touch, turn the bunny upwards #If no touch occurred for a while, turn the bunny downwards #Limit the rotation between slightly up and 90 degrees down (just like Flappy Bird)
    //6. Moving the bunny: moving the bunny with a constant speed while updating the positions of movable objects.
    //7. Setting up a "camera" #code connection, update method
    //8. Loop the ground #copy ground, physics enabled, create doc root var for both
    //9. Coding the ground #
    //10. Create Obstacles:
    //11. Generate obstacles in code
    //12. Spawning endless obstacles
    //13. Generating randomized obstacles: The first step is setting up a custom class for the obstacle.
    //14. Fixing the drawing order
    //15. Setting up a collision
    //16. Implementing "game over" #Bunny falls to ground   #Screen rumbles #Restart button appears     #Game restarts when restart button is pressed
    //17. Scoring Label
