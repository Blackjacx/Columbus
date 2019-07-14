//
//  Extensions.swift
//  Columbus
//
//  Created by Stefan Herold on 14.07.19.
//  Copyright © 2019 CodingCobra. All rights reserved.
//

import UIKit
import SwiftUI

extension Color {
    init(_ name: ColorName) {
        self = Color(name.rawValue)
    }
}
