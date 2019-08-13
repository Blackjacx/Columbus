//
//  UIView+Subviews.swift
//  Columbus
//
//  Created by Stefan Herold on 13.08.19.
//  Copyright © 2019 CodingCobra. All rights reserved.
//

import UIKit

extension UIView {

    func recursiveSubviews() -> [UIView] {

        if subviews.isEmpty {
            return subviews
        }
        return subviews + subviews.flatMap { $0.recursiveSubviews() }
    }
}
