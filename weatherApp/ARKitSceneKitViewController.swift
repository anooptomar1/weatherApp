//
//  ARKitSceneKitViewController.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-20.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import UIKit
import ARKit

class ARKitSceneKitViewController: UIViewController {

    @IBOutlet weak var arscnView: ARSCNView!
    var scnScene: SCNScene!
    
    var translation = matrix_identity_float4x4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translation.columns.3.z = -0.1
        initSecne()
        addSunNode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //initialized an AR configuration called ARWorldTrackingConfiguration for running world tracking
        let configuration = ARWorldTrackingConfiguration()
        arscnView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //tell AR session to stop tracking motion and processing image
        arscnView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSecne() {
        scnScene = SCNScene()
        arscnView.scene = scnScene
    }
    
    func addSunNode() {
//        guard let currentFrame = arscnView.session.currentFrame else { return }
        let sun = Sun()
        if let currentFrame = arscnView.session.currentFrame {
            sun.sunNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        } else {
            sun.sunNode.simdTransform = matrix_multiply(matrix_identity_float4x4, translation)
        }
        scnScene.rootNode.addChildNode(sun.sunNode)
    }
    
    @IBAction func tappedInARSCNView(_ sender: UITapGestureRecognizer) {
        //retrieve the user’s tap location relative to the sceneView
        let tapLocation = sender.location(in: arscnView)
        //hit test to see if we tap onto any node(s).
        let hitTestResults = arscnView.hitTest(tapLocation)
        // safely unwrap the first node from our hitTestResults. If the result does contain at least a node, we will remove the first node we tapped on from its parent node.
        guard let node = hitTestResults.first?.node else {
            //we are not hiting any node, so let's create a new node
            addSunNode()
            return
            
        }
        node.removeFromParentNode()
    }

}
