//
//  Sun.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-20.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import Foundation
import ARKit

class Sun: Node {
    
    var node: SCNNode
    
    init() {
        let radiusOfSphere: Float = 0.01
        let numberOfPyramid:Int = 8
        var pyramidNodeArray: [SCNNode] = [SCNNode]()
        let sunColor = hexStringToUIColor(hex: "#FCD440")
        let pyramidWidth: Float = 0.003
        let pyramidHeight: Float = 0.003
        let pyramidLength: Float = 0.003
        
        let sphereGeometry = SCNSphere(radius: CGFloat(radiusOfSphere))
        sphereGeometry.materials.first?.diffuse.contents = sunColor
        //A node represents the position and the coordinates of an object in a 3D space. By itself, the node has no visible content, we give the node a visible content by setting the node’s geometry.
        let sphereNode = SCNNode(geometry: sphereGeometry)
        
        let centralOfSphereX = sphereNode.position.x
        let centralOfSphereY = sphereNode.position.y
        let centralOfSphereZ = sphereNode.position.z
        let sin45 = sin(Float.pi/4)
        let cos45 = cos(Float.pi/4)
        
        for num in 0..<numberOfPyramid{
            let pyramidGeometry = SCNPyramid(width: CGFloat(pyramidWidth), height: CGFloat(pyramidHeight), length: CGFloat(pyramidLength))
            pyramidGeometry.firstMaterial?.diffuse.contents = sunColor
            let pyramidNode = SCNNode(geometry: pyramidGeometry)
            pyramidNode.rotation = SCNVector4(x: 0, y: 0, z: 1, w: Float.pi / 4 * Float(num))
            sphereNode.addChildNode(pyramidNode)
            pyramidNodeArray.append(pyramidNode)
        }
        
        pyramidNodeArray[0].position = SCNVector3(x:centralOfSphereX, y:centralOfSphereY + radiusOfSphere + pyramidLength/2.0, z:centralOfSphereZ)
        
        pyramidNodeArray[1].position = SCNVector3(x:centralOfSphereX - sin45 * (radiusOfSphere + pyramidLength/2.0), y:centralOfSphereY + cos45 * (radiusOfSphere + pyramidLength/2.0), z:centralOfSphereZ)
        
        pyramidNodeArray[2].position = SCNVector3(x:sphereNode.position.x - radiusOfSphere - pyramidLength/2.0, y:centralOfSphereY, z:centralOfSphereZ)
        
        pyramidNodeArray[3].position = SCNVector3(x:centralOfSphereX - sin45 * (radiusOfSphere + pyramidLength/2.0), y:centralOfSphereY - cos45 * (radiusOfSphere + pyramidLength/2.0), z:centralOfSphereZ)
        
        pyramidNodeArray[4].position = SCNVector3(x:centralOfSphereX, y:sphereNode.position.y - radiusOfSphere - pyramidLength/2.0, z:centralOfSphereZ)
        
        pyramidNodeArray[5].position = SCNVector3(x:centralOfSphereX + sin45 * (radiusOfSphere + pyramidLength/2.0), y:centralOfSphereY - cos45 * (radiusOfSphere + pyramidLength/2.0), z:centralOfSphereZ)
        
        pyramidNodeArray[6].position = SCNVector3(x:sphereNode.position.x + radiusOfSphere + pyramidLength/2.0, y:centralOfSphereY, z:centralOfSphereZ)
        
        pyramidNodeArray[7].position = SCNVector3(x:centralOfSphereX + sin45 * (radiusOfSphere + pyramidLength/2.0), y:centralOfSphereY + cos45 * (radiusOfSphere + pyramidLength/2.0), z:centralOfSphereZ)
        
       self.node = sphereNode.flattenedClone()
        
    }
    
}
