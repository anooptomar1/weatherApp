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

    
    var foundSurface: Bool = false
    var textShowed: Bool = false
    var trackerNode: SCNNode!
    var anchorPosition = SCNVector3Make(0, 0, 0)

    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // we'll have a light source that is continuously updated based on the analyzed real-world light
//        arscnView.autoenablesDefaultLighting = true
        //help smooth jagged edges for the 3D objects
        arscnView.antialiasingMode = .multisampling4X
        //initialized an AR configuration called ARWorldTrackingConfiguration for running world tracking
        let configuration = ARWorldTrackingConfiguration()
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
        if !textShowed {
            guard foundSurface else { return }
            guard let weatherObj = weather else { return }
            let temperature = (weatherObj.temperature ?? 273.15) - 273.15
            //standard string formatting, %.nf where n is the number of decimal places you require
            let textToShow = (weatherObj.cityName ?? "") + " " + (String(format: "%.1f", temperature)) + "°C"
            obj3D = Text(text: textToShow)
//            obj3D = Text(text: "Burnaby")
            obj3D.node.position = anchorPosition
            scnScene.rootNode.addChildNode(obj3D.node)
            trackerNode.removeFromParentNode()
            textShowed = true
        }else {
            switch condition {
            case "Clear":
                obj3D = Sun()
            case "Rain":
                obj3D = RainDrop()
            default:
                obj3D = Cloud()
            }
            if let currentFrame = arscnView.session.currentFrame {
                obj3D.node.simdTransform = matrix_multiply(currentFrame.camera.transform, tNet)
            } else {
                obj3D.node.simdTransform = matrix_multiply(matrix_identity_float4x4, tNet)
            }
            scnScene.rootNode.addChildNode(obj3D.node)
        }

    }
    
    @IBAction func tappedInARSCNView(_ sender: UITapGestureRecognizer) {
        //retrieve the user’s tap location relative to the sceneView
        let tapLocation = sender.location(in: arscnView)
        //hit test to see if we tap onto any node(s).
        let hitTestResults = arscnView.hitTest(tapLocation)
        // safely unwrap the first node from our hitTestResults. If the result does contain at least a node, we will remove the first node we tapped on from its parent node.
        if let node = hitTestResults.first?.node {
            if node.name == "tracker" {
                addNode()
            }else {
                if node.name == "text" {
                    textShowed = false
                    foundSurface = false
                }
                node.removeFromParentNode()
            }
        } else {
            addNode()
        }
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
    
    //calls this method exactly once per frame, so long as the SCNView object (or other SCNSceneRenderer object) displaying the scene is not paused.
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !textShowed else { return }
        //the point to send out a ray in the middle view to detect plane or featurepoint
        let point = CGPoint(x: view.frame.midX, y: view.frame.midY)
        //searches for AR anchors corresponding to a point in the view, Return a list of results, sorted from nearest to farthest (in distance from the camera).
        let hitTest = arscnView.hitTest(point, types: [.existingPlane, .estimatedHorizontalPlane])
        guard let farthestResult = hitTest.first else { return }
        let transform = SCNMatrix4(farthestResult.worldTransform)
        //m41 means last row first column, and the last row offer position stuff
        anchorPosition = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        if !foundSurface {
            let trackerPlane = SCNPlane(width: 0.2, height: 0.2)
            trackerPlane.firstMaterial?.diffuse.contents = UIImage(named: "trackerImg")
            trackerNode = SCNNode(geometry: trackerPlane)
            trackerNode.name = "tracker"
            //eulerAngles does a rotation
            trackerNode.eulerAngles.x = .pi * -0.5
            arscnView.scene.rootNode.addChildNode(trackerNode)
        }
        trackerNode.position = anchorPosition
        foundSurface = true
    }
}
