//
//  Raindrop.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-21.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import Foundation
import ARKit

class RainDrop: Node {
    var node: SCNNode
    
    init() {
        let rainDropColor = hexStringToUIColor(hex: "#AFDDEC")
        let radiusOfSphere: Float = 0.01
        let coneHight: Float = radiusOfSphere * 2
        
        let sphereGeometry = SCNSphere(radius: CGFloat(radiusOfSphere))
        sphereGeometry.materials.first?.diffuse.contents = rainDropColor
        let sphereNode = SCNNode(geometry: sphereGeometry)
        
        let centralOfSphereX = sphereNode.position.x
        let centralOfSphereY = sphereNode.position.y
        let centralOfSphereZ = sphereNode.position.z
        
        let coneGeometry = SCNCone(topRadius: 0, bottomRadius: CGFloat(radiusOfSphere), height: CGFloat(coneHight))
        coneGeometry.materials.first?.diffuse.contents = rainDropColor
        let coneNode = SCNNode(geometry: coneGeometry)
        sphereNode.addChildNode(coneNode)
        
        
        coneNode.position = SCNVector3(x:centralOfSphereX, y:centralOfSphereY + radiusOfSphere, z:centralOfSphereZ)
        
        let raindropNode = sphereNode.flattenedClone()
        self.node = raindropNode
    }
}
