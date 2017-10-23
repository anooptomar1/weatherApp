//
//  ARKitSceneKitViewController.swift
//  weatherApp
//
//  Created by leo  luo on 2017-10-20.
//  Copyright © 2017 tk.onebite.firstClass. All rights reserved.
//

import UIKit
import ARKit

class ARKitSceneKitViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var arscnView: ARSCNView!
    var scnScene: SCNScene!
    var weather: Weather!
    var condition: String = "Clear"
    var obj3D: Node!
    var configuration = ARWorldTrackingConfiguration()
    
//    var foundSurface: Bool = false
//    var hasStarted: Bool = false
//    var trackerNode: SCNNode!
//    var gamePosition = SCNVector3Make(0, 0, 0)
    var showPlanes: Bool = true
    var planes: [String : SCNNode] = [:]
    
    var translation = matrix_identity_float4x4
    var rotation = matrix_identity_float4x4
    var tNet: simd_float4x4!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arscnView.delegate = self
        initSecne()
        initTranslationTranslateMinus1Z()
        initRotationMatrixRotate90AroundZCCW()
        tNet = matrix_multiply(translation, rotation)
//        if let weatherObj = weather {
//        let textNode = Text(text: "Burnaby")
//            scnScene.rootNode.addChildNode(textNode.node)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // we'll have a light source that is continuously updated based on the analyzed real-world light
//        arscnView.autoenablesDefaultLighting = true
        //help smooth jagged edges for the 3D objects
        arscnView.antialiasingMode = .multisampling4X
        //initialized an AR configuration called ARWorldTrackingConfiguration for running world tracking
        configuration.planeDetection = .horizontal
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
//        switch condition {
//        case "Clear":
//            obj3D = Sun()
//        case "Rain":
//            obj3D = RainDrop()
//        default:
//            obj3D = Cloud()
//        }
//        if let currentFrame = arscnView.session.currentFrame {
//            obj3D.node.simdTransform = matrix_multiply(currentFrame.camera.transform, tNet)
//        } else {
//            obj3D.node.simdTransform = matrix_multiply(matrix_identity_float4x4, tNet)
//        }
//        scnScene.rootNode.addChildNode(obj3D.node)
        let text = Text(text: "Burnaby")
        text.node.simdTransform = matrix_multiply(matrix_identity_float4x4, tNet)
        scnScene.rootNode.addChildNode(text.node)
    }
    
    @IBAction func tappedInARSCNView(_ sender: UITapGestureRecognizer) {
        //retrieve the user’s tap location relative to the sceneView
        let tapLocation = sender.location(in: arscnView)
        //hit test to see if we tap onto any node(s).
        let hitTestResults = arscnView.hitTest(tapLocation)
        // safely unwrap the first node from our hitTestResults. If the result does contain at least a node, we will remove the first node we tapped on from its parent node.
//        guard let node = hitTestResults.first?.node else {
            //we are not hiting any node, so let's create a new node
            addNode()
            return
            
//        }
//        node.removeFromParentNode()
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
    
    func initRotationMatrixRotate90AroundZCCW() {
        rotation.columns.0.x = 0
        rotation.columns.0.y = 1
        rotation.columns.1.x = -1
        rotation.columns.1.y = 0
    }
    
    func initTranslationTranslateMinus1Z() {
        translation.columns.3.z = -0.1
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        guard !hasStarted else { return }
//        //the point to send out a ray in the middle view to detect plane or featurepoint
//        let point = CGPoint(x: view.frame.midX, y: view.frame.midY)
//        //searches for AR anchors corresponding to a point in the view, Return a list of results, sorted from nearest to farthest (in distance from the camera).
//        let hitTest = arscnView.hitTest(point, types: [.existingPlane, .estimatedHorizontalPlane])
//        if let farthestResult = hitTest.last {
//            let anchor = ARAnchor(transform: farthestResult.worldTransform)
//            arscnView.session.add(anchor: anchor)
//        }
//    }
    
    //called when a plane is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        //to add a child node to the generated one that covers the plane
        let key = planeAnchor.identifier.uuidString
        let planeNode = NodeGenerator.generatePlaneFrom(planeAnchor: planeAnchor, physics: true, hidden: !self.showPlanes)
        //add our custom planeNode as a child of the node provided from the renderer.
        node.addChildNode(planeNode)
        //keep a reference to our new node in a dictionary so we can make updates later.
        self.planes[key] = planeNode
        //turn off planeDetection
//        configuration.planeDetection = []
//        arscnView.session.run(configuration)
    }
    //the engine decides to update a registered plan, we need to re-assign the proper geometry and position
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let key = planeAnchor.identifier.uuidString
        if let existingPlane = self.planes[key] {
            NodeGenerator.update(planeNode: existingPlane, from: planeAnchor, hidden: !self.showPlanes)
        }
    }
    //handling when planes are removed from the scene. This happens when multiple existing planes are merged into one. 
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let key = planeAnchor.identifier.uuidString
        if let existingPlane = self.planes[key] {
            existingPlane.removeFromParentNode()
            self.planes.removeValue(forKey: key)
        }
    }
    
}
