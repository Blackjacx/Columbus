//
//  Configuration.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import SwiftUI

public protocol Configuration {
    var shadowRadius: CGFloat { get }
    var textAttributes: [NSAttributedString.Key: Any] { get }
    var lineWidth: CGFloat { get }
    var rasterSize: CGFloat { get }
    var separatorInsets: UIEdgeInsets { get }
    var searchBarPlaceholder: String { get }
    var flagWidth: CGFloat { get }
}

public struct DefaultConfig: Configuration {
    public var shadowRadius: CGFloat = 5.0
    public var textAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20)]
    public var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    public var rasterSize: CGFloat = 12.0
    public var separatorInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: rasterSize, bottom: 0, right: rasterSize)
    }
    public var searchBarPlaceholder: String = "Search"
    public var flagWidth: CGFloat = 30

    public init() {}
}

public enum ColorName: String {
    case text
    case line
    case shadow
    case control
}
