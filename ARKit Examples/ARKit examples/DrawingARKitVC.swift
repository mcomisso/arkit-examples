//
//  DrawingARKitVC.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 02/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import ARKit

class DrawingViewController: BaseARKitVC {

    @IBOutlet weak var drawButton: UIButton!

    let pointerNode = SCNNode(geometry: SCNSphere(radius: 0.02))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView.delegate = self
        self.configuration.isLightEstimationEnabled = false
        self.sceneView.scene.rootNode.addChildNode(self.pointerNode)
        pointerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
    }
}


extension DrawingViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {

        guard let pointOfView = self.sceneView.pointOfView else { return }
        let transform = pointOfView.transform

        // Orientation is in column 3
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        // Location is in column 4
        let location = SCNVector3.init(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location


        self.pointerNode.position = SCNVector3.init(currentPositionOfCamera.x, currentPositionOfCamera.y, currentPositionOfCamera.z)


        DispatchQueue.main.async {
            if self.drawButton.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere.init(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)

                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
        }
    }
}



