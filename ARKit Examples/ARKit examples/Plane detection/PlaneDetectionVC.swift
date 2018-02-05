//
//  PlaneDetectionVC.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 03/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import ARKit

class PlaneDetectionViewController: BaseARKitVC {

    var listenerNode: SCNNode?

    var bananaNode: SCNNode!

    lazy var togglePhisics: UISwitch = { [weak self] in
        guard let `self` = self else { fatalError() }
        let phisicsSwitch = UISwitch.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        phisicsSwitch.translatesAutoresizingMaskIntoConstraints = false
        phisicsSwitch.addTarget(self, action: #selector(self.didTogglePhisics(_:)), for: .valueChanged)

        self.view.addSubview(phisicsSwitch)
        NSLayoutConstraint.activate([phisicsSwitch.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     phisicsSwitch.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)])
        return phisicsSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(self.configuration, options: [.resetTracking, .removeExistingAnchors])
        self.sceneView.delegate = self
        if let scene = SCNScene.init(named: "art.scnassets/banana.scn"),
            let bananaNode = scene.rootNode.childNode(withName: "banana", recursively: false) {
            self.bananaNode = bananaNode
        }

        self.togglePhisics.isOn = false

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    func createGround(planeAnchor: ARPlaneAnchor) -> SCNNode {

        let groundNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        groundNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "ground")
        groundNode.geometry?.firstMaterial?.isDoubleSided = true
        groundNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        groundNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        groundNode.physicsBody = SCNPhysicsBody.static()

        return groundNode
    }

    @objc func didTogglePhisics(_ sender: UISwitch) {
        if sender.isOn {
            self.bananaNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape:
                SCNPhysicsShape(node: self.bananaNode, options: [SCNPhysicsShape.Option.keepAsCompound: true,
                                                            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
        } else {
            self.bananaNode.physicsBody = nil
        }
    }

    @objc func didTap(_ tapgestureRecognizer: UITapGestureRecognizer) {
        guard let sceneView = tapgestureRecognizer.view as? ARSCNView else {
            return
        }

        let location = tapgestureRecognizer.location(in: sceneView)
        let hitTest = sceneView.hitTest(location, types: .existingPlaneUsingExtent)

        if hitTest.isEmpty {
            return
        } else {
            self.addBanana(hitTestResult: hitTest.first!)
        }
    }

    func addBanana(hitTestResult: ARHitTestResult) {

        let bananaCopy = self.bananaNode.copy() as! SCNNode

        let thirdColumn = hitTestResult.worldTransform.columns.3
        bananaCopy.position = SCNVector3(thirdColumn.x, thirdColumn.y + 0.05, thirdColumn.z)

        let screamSource = SCNAudioSource(fileNamed: "nonoargh.mp3")!
        screamSource.loops = false
        screamSource.isPositional = true
        screamSource.load()

        self.sceneView.scene.rootNode.addChildNode(bananaCopy)

        if self.togglePhisics.isOn {
            let audioPlayer = SCNAudioPlayer.init(source: screamSource)
            bananaCopy.addAudioPlayer(audioPlayer)
        }
    }
}


extension PlaneDetectionViewController: ARSCNViewDelegate {

    //    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
    //        renderer.audioListener = self.sceneView.pointOfView
    //    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Plane anchor

        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        node.addChildNode(createGround(planeAnchor: planeAnchor))

        print("New flat surface.")
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Gets update when a new node gets updated
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        for child in node.childNodes {
            child.removeFromParentNode()
        }

        let groundNode = createGround(planeAnchor: planeAnchor)
        node.addChildNode(groundNode)

        print("Updating anchor")
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // When the renderer detects an error
        for child in node.childNodes {
            child.removeFromParentNode()
        }
    }

}
