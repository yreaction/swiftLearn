//
//  GameScene.swift
//  trigonometriaAcelerometro
//
//  Created by Juan Pedro Lozano on 30/07/14.
//  Copyright (c) 2014 Juan Pedro Lozano. All rights reserved.
//

import SpriteKit
import CoreMotion



class GameScene: SKScene {
    
    let colorBck = UIColor(red: 94.0/255, green: 63.0/255.0, blue: 107.0/255, alpha: 1)
    let spaceShip = SKSpriteNode(imageNamed: "Player")
    
    func vectorLength (a:CGPoint) -> Float {
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
    
    override func didMoveToView(view: SKView) {
    
        self.backgroundColor = colorBck
        spaceShip.position = CGPoint(x: self.frame.width/2, y: 60.0)
        self.addChild(spaceShip)
    
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
        if self.childNodeWithName("coorShape") {
            self.enumerateChildNodesWithName("coorShape", usingBlock: {node,stop in node.removeAllChildren()})

        }
        let touch:UITouch = touches.anyObject() as UITouch
        let position = touch.locationInNode(self)
        
        let offSet = self.vectorSub(position, b: spaceShip.position)
        let distance = self.vectorDistance(position, b: spaceShip.position)
        let normalize = self.vectorNormalize(offSet)
        let angleToRotate = atan2(normalize.x, normalize.y)
        
        self.addPoints([position,spaceShip.position,offSet])
        spaceShip.hidden = true

        
        println("Touch: \(position) Ship: \(spaceShip.position) offSet: \(offSet) distance: \(distance) normalize: \(angleToRotate) ")
//        let duration =angleToRotate > M_PI_2 ? angleToRotate/2.0 : (angleToRotate + M_PI_2)/2.0

       spaceShip.runAction(SKAction.group([SKAction.moveTo(position, duration: distance*0.005),SKAction.rotateToAngle(-angleToRotate, duration: (distance*0.001))]))
    }
    override func update(currentTime: NSTimeInterval)  {
    }
}
