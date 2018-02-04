//
//  SecondVC.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 02/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class SecondViewController: BaseARKitVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addShape(_ sender: Any) {

        if let lastNode = self.sceneView.scene.rootNode.childNodes.last {

            lastNode.parent?.addChildNode(self.addNode(away: lastNode))
        }


        let node = SCNNode()
        node.geometry = SCNCapsule(capRadius: 0.1, height: 0.3)
        // SCNBox
        // SCNCone
        // SCNCylindere
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.position = SCNVector3(0, 0, -1)
        self.sceneView.scene.rootNode.addChildNode(node)
    }

    @IBAction func reset(_ sender: Any) {
        // Needs to pause the session

        self.resetSession()
    }

    func addNode(away fromNode: SCNNode) -> SCNNode {
        let node = SCNNode()
        node.geometry = SCNCapsule(capRadius: 0.1, height: 0.3)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        let x = fromNode.position.x + 0.3
        node.position = SCNVector3.init(x, 0, fromNode.position.z)
        return node
    }

    private func resetSession() {
        self.sceneView.session.pause()
        for node in self.sceneView.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }

        self.sceneView.session.run(self.configuration, options: [.resetTracking, .removeExistingAnchors])
    }

}
