//
//  EarthVC.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 02/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class EarthVC: BaseARKitVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()

        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun Diffuse")
        sun.position = SCNVector3(0,0,-1)
        earthParent.position = SCNVector3(0,0,-1)
        venusParent.position = SCNVector3(0,0,-1)
        moonParent.position = SCNVector3(1.2 ,0 , 0)

        self.sceneView.scene.rootNode.addChildNode(sun)
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)


        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earth Day"), specular: #imageLiteral(resourceName: "Earth Specular"), emission: #imageLiteral(resourceName: "Earth Clouds"), normal: #imageLiteral(resourceName: "Earth Normal"), position: SCNVector3(1.2 ,0 , 0))
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "Venus Surface"), specular: nil, emission: #imageLiteral(resourceName: "Venus Atmosphere"), normal: nil, position: SCNVector3(0.7, 0, 0))
        let moon = planet(geometry: SCNSphere(radius: 0.05), diffuse: #imageLiteral(resourceName: "moon Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))



        let sunAction = rotation(time: 8)
        let earthParentRotation = rotation(time: 14)
        let venusParentRotation = rotation(time: 10)
        let earthRotation = rotation(time: 8)
        let moonRotation = rotation(time: 5)
        let venusRotation = rotation(time: 8)


        earth.runAction(earthRotation)
        venus.runAction(venusRotation)
        earthParent.runAction(earthParentRotation)
        venusParent.runAction(venusParentRotation)
        moonParent.runAction(moonRotation)


        sun.runAction(sunAction)
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venus)
        earth.addChildNode(moon)
        moonParent.addChildNode(moon)

    }

    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet

    }

    func rotation(time: TimeInterval) -> SCNAction {
        let Rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(Rotation)
        return foreverRotation
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

/*


final class EarthVC: BaseARKitVC {


    override func viewDidLoad() {
        super.viewDidLoad()

        let sun = PlanetGenerator.generatePlanet(dimension: 0.35, diffuse: #imageLiteral(resourceName: "Sun Diffuse"), position: SCNVector3(0, 0, -1))

        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()

        earthParent.position = SCNVector3.init(0, 0, -1)
        venusParent.position = SCNVector3.init(0, 0, -1)
        moonParent.position = SCNVector3.init(1.2, 0, 0)

        [sun, earthParent, venusParent].forEach { [weak self] in
            self?.sceneView.scene.rootNode.addChildNode($0)
        }

        let earth = PlanetGenerator.generatePlanet(dimension: 0.2, diffuse: #imageLiteral(resourceName: "Earth Day"), normal: #imageLiteral(resourceName: "Earth Normal"), specular: #imageLiteral(resourceName: "Earth Specular"), emission: #imageLiteral(resourceName: "Earth Clouds"), position: SCNVector3(1.2, 0, 0))
        let venus = PlanetGenerator.generatePlanet(dimension: 0.1, diffuse: #imageLiteral(resourceName: "Venus Diffuse"), position: SCNVector3(0.7, 0, 0))
        let moon = PlanetGenerator.generatePlanet(dimension: 0.05, diffuse: UIImage(), position: SCNVector3(0, 0, -0.3))

        earthParent.addChildNode(earth)
        venusParent.addChildNode(venus)
        moonParent.addChildNode(moon)

        let sunAction = PlanetGenerator.infiniteRotateAction(duration: 8)
        let earthParentRotation = PlanetGenerator.infiniteRotateAction(duration: 14)
        let venusParentRotation = PlanetGenerator.infiniteRotateAction(duration: 10)
        let earthRotation = PlanetGenerator.infiniteRotateAction(duration: 8)
        let moonRotation = PlanetGenerator.infiniteRotateAction(duration: 5)
        let venusRotation = PlanetGenerator.infiniteRotateAction(duration: 8)

        earth.runAction(earthRotation)
        venus.runAction(venusRotation)
        moon.runAction(moonRotation)
        earthParent.runAction(earthParentRotation)
        venusParent.runAction(venusParentRotation)

        sun.runAction(sunAction)

        [sun, earthParent, venusParent].forEach { [weak self] in
            self?.sceneView.scene.rootNode.addChildNode($0)
        }

    }

}


class SCNPlanet: SCNNode {
    let parentPlanetNode: SCNNode
    let radius: CGFloat

    init(parentPosition: SCNVector3, radius: CGFloat) {
        self.parentPlanetNode = SCNNode()
        self.parentPlanetNode.position = parentPosition

        self.radius = radius

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}

class PlanetGenerator {

    static func infiniteRotateAction(duration: TimeInterval) -> SCNAction {
        let action = SCNAction.rotateBy(x: 0, y: 360.degreesToRadians, z: 0, duration: 4)
        let forever = SCNAction.repeatForever(action)
        return forever
    }

    static func generatePlanet(dimension: CGFloat,
                               diffuse: UIImage,
                               normal: UIImage? = nil,
                               specular: UIImage? = nil,
                               emission: UIImage? = nil,
                               position: SCNVector3) -> SCNNode {

        let planet = SCNNode(geometry: SCNSphere(radius: dimension))
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission

        planet.position = position

        return planet
    }
}
*/
