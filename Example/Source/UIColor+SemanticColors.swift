//
//  UIColor+SemanticColors.swift
//  Columbus-iOS
//
//  Created by Stefan Herold on 31.01.20.
//  Copyright © 2022 Stefan Herold. All rights reserved.
//

import UIKit

extension UIColor {
    static let text: UIColor = .label
    static let line: UIColor = .separator
    static let placeholder: UIColor = .placeholderText

    static let background: UIColor = UIColor(dynamicProvider: { (traits) in
        switch traits.userInterfaceStyle {
        case (.dark):   return UIColor(white: 0.1, alpha: 1)
        default:        return .white
        }
    })

    static let selection: UIColor = UIColor(dynamicProvider: { (traits) in
        switch traits.userInterfaceStyle {
        case (.dark):   return .darkGray
        default:        return UIColor(white: 0.9, alpha: 1.0)
        }
    })
}
