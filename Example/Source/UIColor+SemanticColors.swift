//
//  UIColor+SemanticColors.swift
//  Columbus-iOS
//
//  Created by Stefan Herold on 31.01.20.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

extension UIColor {

    static let background: UIColor = {
        if #available(iOS 13, *) {
            return UIColor(dynamicProvider: { (traits) in
                switch(traits.userInterfaceStyle) {
                case (.dark):   return UIColor(white: 0.1, alpha: 1)
                default:        return .white
                }
            })
        } else {
            return .white
        }
    }()

    static let text: UIColor = {
        if #available(iOS 13, *) {
            return .label
        } else {
            return .systemGray
        }
    }()

    static let textFieldBackground: UIColor = {
        if #available(iOS 13, *) {
            return UIColor(dynamicProvider: { (traits) in
                switch(traits.userInterfaceStyle) {
                case (.dark):   return UIColor(white: 0, alpha: 0.3)
                default:        return UIColor(white: 0, alpha: 0.1)
                }
            })
        } else {
            return UIColor(white: 0, alpha: 0.1)
        }
    }()

    static let line: UIColor = {
        if #available(iOS 13, *) {
            return .separator
        } else {
            return .lightGray
        }
    }()

    static let placeholder: UIColor = {
        if #available(iOS 13, *) {
            return .placeholderText
        } else {
            return .systemGray
        }
    }()

    static let selection: UIColor = {
        if #available(iOS 13, *) {
            return UIColor(dynamicProvider: { (traits) in
                switch(traits.userInterfaceStyle) {
                case (.dark):   return .darkGray
                default:        return UIColor(white: 0.9, alpha: 1.0)
                }
            })
        } else {
            return UIColor(white: 0.9, alpha: 1.0)
        }
    }()
}
