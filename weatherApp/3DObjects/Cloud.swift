//
//  Cloud.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-21.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import Foundation
import ARKit

class Cloud: Node {
    
    var node: SCNNode
    
    init() {
        let cloudColor = hexStringToUIColor(hex: "#F3F3F2")
        
        let radiusOfSphereMiddle: Float = 0.01
        let sphereMiddleGeometry = SCNSphere(radius: CGFloat(radiusOfSphereMiddle))
        sphereMiddleGeometry.materials.first?.diffuse.contents = cloudColor
        let sphereMiddleNode = SCNNode(geometry: sphereMiddleGeometry)
        
        let radiusOfSphereLeft: Float = radiusOfSphereMiddle * 0.65
        let sphereLeftGeometry = SCNSphere(radius: CGFloat(radiusOfSphereLeft))
        sphereLeftGeometry.materials.first?.diffuse.contents = cloudColor
        let sphereLeftNode = SCNNode(geometry: sphereLeftGeometry)
        sphereMiddleNode.addChildNode(sphereLeftNode)
        
        let radiusOfSphereRight: Float = radiusOfSphereMiddle * 0.75
        let sphereRightGeometry = SCNSphere(radius: CGFloat(radiusOfSphereRight))
        sphereRightGeometry.materials.first?.diffuse.contents = cloudColor
        let sphereRightNode = SCNNode(geometry: sphereRightGeometry)
        sphereMiddleNode.addChildNode(sphereRightNode)
        
        let centralOfMiddleSphereX = sphereMiddleNode.position.x
        let centralOfMiddleSphereY = sphereMiddleNode.position.y
        let centralOfMiddleSphereZ = sphereMiddleNode.position.z
        
        sphereLeftNode.position = SCNVector3(x:centralOfMiddleSphereX - radiusOfSphereMiddle + radiusOfSphereLeft * 0.3, y:centralOfMiddleSphereY, z:centralOfMiddleSphereZ)
        sphereRightNode.position = SCNVector3(x:centralOfMiddleSphereX + radiusOfSphereMiddle - radiusOfSphereRight * 0.2, y:centralOfMiddleSphereY, z:centralOfMiddleSphereZ)
        
        let cloudNode = sphereMiddleNode.flattenedClone()
        self.node = cloudNode
    }
}
