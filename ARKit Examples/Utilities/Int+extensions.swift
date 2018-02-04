//
//  Int+extensions.swift
//  ARKit Examples
//
//  Created by Matteo Comisso on 02/02/2018.
//  Copyright © 2018 ReatailMeNot UK Ltd. All rights reserved.
//

import Foundation
import CoreGraphics

extension Int {
    var degreesToRadians: CGFloat {
        return (CGFloat(self) * CGFloat(Double.pi/180))
    }
}
