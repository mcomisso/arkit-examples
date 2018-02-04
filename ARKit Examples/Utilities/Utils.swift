//
//  Utils.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 03/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import ARKit

// SCNVector3 add
func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}
