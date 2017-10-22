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
    var weather: Weather!
    var condition: String = "Clear"
    var obj3D: Node!
    
    var translation = matrix_identity_float4x4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translation.columns.3.z = -0.1
        initSecne()
        arscnView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
//        addSunNode()
        if let weatherObj = weather {
            print(weatherObj.condition ?? "...")
        }
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
    
    func addNode() {
        switch condition {
        case "Clear":
            obj3D = Sun()
        case "Rain":
            obj3D = RainDrop()
        default:
            obj3D = Cloud()
        }
        if let currentFrame = arscnView.session.currentFrame {
            obj3D.node.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        } else {
            obj3D.node.simdTransform = matrix_multiply(matrix_identity_float4x4, translation)
        }
        scnScene.rootNode.addChildNode(obj3D.node)
    }
    
    @IBAction func tappedInARSCNView(_ sender: UITapGestureRecognizer) {
        //retrieve the user’s tap location relative to the sceneView
        let tapLocation = sender.location(in: arscnView)
        //hit test to see if we tap onto any node(s).
        let hitTestResults = arscnView.hitTest(tapLocation)
        // safely unwrap the first node from our hitTestResults. If the result does contain at least a node, we will remove the first node we tapped on from its parent node.
        guard let node = hitTestResults.first?.node else {
            //we are not hiting any node, so let's create a new node
            addNode()
            return
            
        }
        node.removeFromParentNode()
    }

    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            condition = "Clear"
        case 2:
            condition = "Rain"
        default:
            condition = "Clouds"
        }
    }
    
}
