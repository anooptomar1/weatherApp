//
//  Text.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-21.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import Foundation
import ARKit

class Text: Node {
    
    struct CollisionTypes : OptionSet {
        let rawValue: Int
        
        static let bottom  = CollisionTypes(rawValue: 1 << 0)
        static let shape = CollisionTypes(rawValue: 1 << 1)
    }
    
    var node: SCNNode
    let scaleUnit: Float = 0.0001
    init(text: String) {
        let geometry = SCNText(string: text, extrusionDepth: 5)
        let textNode = SCNNode(geometry: geometry)
        textNode.scale = SCNVector3(x:scaleUnit, y:scaleUnit, z:scaleUnit)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape:SCNPhysicsShape(geometry: geometry, options: nil))
        physicsBody.mass = 1.25
        physicsBody.restitution = 0.25
        physicsBody.friction = 0.75
        physicsBody.categoryBitMask = CollisionTypes.shape.rawValue
        textNode.physicsBody = physicsBody
        self.node = textNode
    }
}
