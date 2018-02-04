//
//  BaseARKitVC.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 02/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class BaseARKitVC: UIViewController {

    lazy var sceneView: ARSCNView = { [weak self] in
        let sceneView = ARSCNView(frame: self!.view.frame)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        self?.view.insertSubview(sceneView, at: 0)

        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: self!.view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: self!.view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: self!.view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: self!.view.bottomAnchor)])

        return sceneView
    }()

    lazy var toggleDebugView: UISwitch = { [weak self] in
        guard let `self` = self else { fatalError() }
        let toggle = UISwitch.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(self.toggle(_:)), for: .valueChanged)

        self.view.addSubview(toggle)

        NSLayoutConstraint.activate([
            sceneView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)])

        return toggle
    }()


    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        self.sceneView.session.run(self.configuration)
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.showsStatistics = true

        self.toggleDebugView.isOn = (self.sceneView.debugOptions.isEmpty == false)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.sceneView.session.pause()
    }

    @objc func toggle(_ toggle: UISwitch) {
        if toggle.isOn {
            self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        } else {
            self.sceneView.debugOptions = []
        }

    }
}
