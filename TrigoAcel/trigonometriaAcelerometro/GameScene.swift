//
//  GameScene.swift
//  trigonometriaAcelerometro
//
//  Created by Juan Pedro Lozano on 30/07/14.
//  Copyright (c) 2014 Juan Pedro Lozano. All rights reserved.
//



import SpriteKit
import CoreMotion

enum gameCategorias:UInt32 {
    case shipCategory = 1
    case torretCategory = 2
    case edgeCategory = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let colorBck = UIColor(red: 94.0/255, green: 63.0/255.0, blue: 107.0/255, alpha: 1)
    let spaceShip = SKSpriteNode(imageNamed: "Player")
    let cannonSprite = SKSpriteNode(imageNamed: "Cannon")
    let turretSprite = SKSpriteNode(imageNamed: "Turret")

    //
    let maxHp = 100
    let healthBarWith:CGFloat = 40.0
    let healthBarHeight:CGFloat = 4.0
    var playerHp:Int?
    var turretHp:Int?
    
    let playerHealthBar = SKNode ()
    let cannonHealthBar = SKNode ()
    
    func vectorLength (a:CGPoint) -> CGFloat {
        //pitagoras - oposite2 + adjacent2 = hypo2
        return sqrt(a.x * a.x * a.y * a.y)
    }
    
    func vectorDistance (a:CGPoint, b:CGPoint) -> Double {
        let returnValue = Double (sqrt(pow((a.x - b.x), 2.0) + pow((a.y - b.y), 2.0)))
        return returnValue
    }
    
    func vectorSub (a:CGPoint, b:CGPoint) -> CGPoint {
        return CGPointMake(a.x - b.x,a.y - b.y)
    }
    
    func vectorNormalize (a:CGPoint) -> CGPoint {
        let length = vectorLength(a)
        return CGPointMake(a.x/length , a.y/length)
    }
    
    func updateTurret(dt:NSTimeInterval) {
        let distance:CGPoint = self.vectorSub(spaceShip.position, b: turretSprite.position)
        let angle = -atan2(distance.x, distance.y)
        turretSprite.zRotation = angle - ((90/360) * 2 * Int(M_PI))
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        
        var notTheBall:SKPhysicsBody?;
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            notTheBall = contact.bodyB
        } else {
            notTheBall = contact.bodyA
        }
        if notTheBall?.categoryBitMask == gameCategorias.torretCategory.toRaw() {
            //Brick touch
           playerHp = playerHp! - 10
           spaceShip.removeAllActions()
           spaceShip.physicsBody.applyImpulse(CGVectorMake(1, 1))
           self.addHealthBar(playerHealthBar, name: "Fu", hp: playerHp!)
            
        } else {
            //Paddle
        }

    }

    override func didMoveToView(view: SKView) {
    
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsWorld.gravity = CGVector (0,0)
        self.physicsBody.categoryBitMask = gameCategorias.edgeCategory.toRaw()
        self.backgroundColor = colorBck
        self.physicsWorld.contactDelegate = self
        
        spaceShip.position = CGPoint(x: self.frame.width/2, y: 60.0)
        spaceShip.physicsBody = SKPhysicsBody(rectangleOfSize: spaceShip.frame.size)
        spaceShip.physicsBody.categoryBitMask = gameCategorias.shipCategory.toRaw()
        playerHp = maxHp
        cannonSprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        cannonSprite.physicsBody = SKPhysicsBody(circleOfRadius: cannonSprite.size.width/2)
        cannonSprite.physicsBody.categoryBitMask = gameCategorias.torretCategory.toRaw()
        cannonSprite.physicsBody.contactTestBitMask = gameCategorias.shipCategory.toRaw()
        cannonSprite.physicsBody.dynamic = false
        turretHp = maxHp
        
        self.addChild(cannonSprite)
        
        turretSprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))

        
        self.addChild(turretSprite)
        self.addChild(spaceShip)
        self.addHealthBar(playerHealthBar, name: "spaceBar", hp: playerHp!)
        self.addHealthBar(cannonHealthBar, name: "cannon", hp: turretHp!)
        self.addChild(playerHealthBar)
        self.addChild(cannonHealthBar)
    }

    
    func addHealthBar(node:SKNode, name:String, hp:Int) {
        node.removeAllChildren()
        let widthOfHealth = CGFloat((healthBarWith - 2.0)*hp/maxHp)
 
        
        let clearColor = SKColor.clearColor()
        let fillColor = UIColor(red: 133/255, green: 202/255, blue: 53/255, alpha: 1)
        let borderColor = UIColor(red: 35/255, green: 28/255, blue: 40/255, alpha: 1)

        //create the outline for the health bar
        let outlineRectSize = CGSizeMake(healthBarWith-1.0, healthBarHeight-1.0)
        UIGraphicsBeginImageContextWithOptions(outlineRectSize, false, 0.0)
        var healthBarContext = UIGraphicsGetCurrentContext()
        
        //Drawing the outline for the health bar
        let spriteOutlineRect = CGRectMake(0.0, 0.0, healthBarWith-1.0, healthBarHeight-1.0)
        CGContextSetStrokeColorWithColor(healthBarContext, borderColor.CGColor)
        CGContextSetLineWidth(healthBarContext, 1.0)
        CGContextAddRect(healthBarContext, spriteOutlineRect)
        CGContextStrokePath(healthBarContext)
        
        //Fill the health bar with a filled rectangle
        var  spriteFillRect = CGRectMake(0.5, 0.5, outlineRectSize.width - 1, outlineRectSize.height - 1)
        spriteFillRect.size.width = widthOfHealth
        CGContextSetFillColorWithColor(healthBarContext, fillColor.CGColor)
        CGContextSetStrokeColorWithColor(healthBarContext, clearColor.CGColor)
        CGContextSetLineWidth(healthBarContext, 1.0)
        CGContextFillRect(healthBarContext, spriteFillRect)
        
        //Generate a sprite image of the two pieces for display
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let spriteCGImageRef = spriteImage.CGImage
        let spriteTexture = SKTexture(CGImage: spriteCGImageRef)
        let frameSprite = SKSpriteNode(texture: spriteTexture, size: outlineRectSize)//[SKSpriteNode spriteNodeWithTexture:spriteTexture size:outlineRectSize];
        frameSprite.position = CGPointZero
        frameSprite.name = name
        frameSprite.anchorPoint = CGPointMake(0.0, 0.5)
        
        node.addChild(frameSprite)
    }
    
    func addPoints (apoint: [CGPoint]) {
        
        for x in apoint {
        let shape = SKShapeNode(rect: CGRectMake(x.x, x.y, 10, 10))
        shape.lineWidth = 0
        shape.fillColor = SKColor.whiteColor()
        shape.name = "coorShape"
        self.addChild(shape)
        }
    }


    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        spaceShip.removeAllActions()
        spaceShip.physicsBody.applyImpulse(CGVectorMake(0, 0))
        if self.childNodeWithName("coorShape") {
            self.enumerateChildNodesWithName("coorShape", usingBlock: {node,stop in node.removeAllChildren()})
        }
        
        let touch:UITouch = touches.anyObject() as UITouch
        let position = touch.locationInNode(self)
        if !CGRectContainsPoint(spaceShip.frame, position) {
        let offSet = self.vectorSub(position, b: spaceShip.position)
        let distance = self.vectorDistance(position, b: spaceShip.position)
        let normalize = self.vectorNormalize(offSet)
        let angleToRotate = atan2(normalize.x, normalize.y)

        spaceShip.runAction(SKAction.group([SKAction.moveTo(position, duration: distance*0.005),SKAction.rotateToAngle(-angleToRotate, duration: (distance*0.001))]))
        }
    }
    
    override func update(currentTime: NSTimeInterval)  {
        
        self.updateTurret(currentTime)
        playerHealthBar.position = CGPoint(x:CGRectGetMinX(spaceShip.frame), y:CGRectGetMaxY(spaceShip.frame))
        cannonHealthBar.position = CGPoint(x:CGRectGetMinX(cannonSprite.frame), y:CGRectGetMaxY(cannonSprite.frame))
    }
}
