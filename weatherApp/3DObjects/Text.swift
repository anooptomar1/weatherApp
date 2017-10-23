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

    var node: SCNNode
    let scaleUnit: Float = 0.01
    
    init(text: String) {
        let geometry = SCNText(string: text, extrusionDepth: 3)
        let textNode = SCNNode(geometry: geometry)
        textNode.name = "text"
        textNode.scale = SCNVector3(x:scaleUnit, y:scaleUnit, z:scaleUnit)
        self.node = textNode
    }
    
}
