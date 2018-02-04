//
//  BasketBallVC.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 04/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import ARKit

class BasketBallVC: BaseARKitVC {


    var isBasketAdded: Bool {
        get {
            return self.sceneView.scene.rootNode.childNode(withName: "basketball", recursively: false) != nil
        }
    }

    var power: Float = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configuration.planeDetection = .horizontal

        self.sceneView.delegate = self
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap(_:)))
        self.sceneView.addGestureRecognizer(tap)
    }

    @objc func didTap(_ tapGestureRecogn: UITapGestureRecognizer) {
        guard let sceneView = tapGestureRecogn.view as? ARSCNView else {
            return
        }

        let touchLocation = tapGestureRecogn.location(in: sceneView)
        let hitTest = sceneView.hitTest(touchLocation, types: [.existingPlaneUsingExtent])

        if let first = hitTest.first {
            self.addBasket(hitTestResult: first)
        }

    }

    func addBasket(hitTestResult: ARHitTestResult) {

        if self.isBasketAdded == false {
            let scene = SCNScene.init(named: "basketball.scnassets/Basketball.scn")
            guard let firstNode = scene?.rootNode.childNode(withName: "basketball", recursively: false) else { return }

            let position = hitTestResult.worldTransform.columns.3
            firstNode.position = SCNVector3.init(position.x, position.y, position.z)

            firstNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: firstNode, options: [SCNPhysicsShape.Option.keepAsCompound: true,
                                                                                                                    SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))

            self.sceneView.scene.rootNode.addChildNode(firstNode)

        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        //
        if self.isBasketAdded {
            guard let pointOfView = self.sceneView.pointOfView else {
                return
            }
            let transform = pointOfView.transform
            let location = SCNVector3.init(transform.m41, transform.m42, transform.m43)
            let orientation = SCNVector3.init(-transform.m31, -transform.m32, -transform.m33)
            let position = location + orientation

            self.power = 5

            let ball = SCNNode(geometry: SCNSphere.init(radius: 0.2))
            ball.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            ball.position = position

            let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape.init(node: ball))
            ball.physicsBody = body

            ball.physicsBody?.applyForce(SCNVector3(orientation.x * power, orientation.y * power, orientation.z*power), asImpulse: true)

            self.sceneView.scene.rootNode.addChildNode(ball)

        }
    }
}

extension BasketBallVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //

        guard anchor is ARPlaneAnchor else {
            return
        }
        DispatchQueue.main.async {
            // Display
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Hide
        }



    }
}
