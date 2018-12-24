//
//  Configuration.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import UIKit

public protocol Configuration {
    var textColor: UIColor { get }
    var textAttributes: [NSAttributedString.Key: Any] { get }
    var lineColor: UIColor { get }
    var lineWidth: CGFloat { get }
    var rasterSize: CGFloat { get }
    var backgroundColor: UIColor { get }
    var separatorInsets: UIEdgeInsets { get }
    var controlColor: UIColor { get }
    var searchBarPlaceholder: String? { get }
}

public struct DefaultConfig: Configuration {
    public var textColor: UIColor = .darkGray
    public var textAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20)]
    public var lineColor: UIColor = .lightGray
    public var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    public var rasterSize: CGFloat = 12.0
    public var backgroundColor: UIColor = .white
    public var separatorInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: rasterSize, bottom: 0, right: rasterSize)
    }
    public var controlColor: UIColor = UIColor(red: 1.0/255.0, green: 192.0/255.0, blue: 1, alpha: 1)
    public var searchBarPlaceholder: String? = "Search"

    public init() {}
}

public struct DarkModeConfig: Configuration {
    public var textColor: UIColor = .white
    public var textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .ultraLight)
    ]
    public var lineColor: UIColor = .lightGray
    public var lineWidth: CGFloat = 3.0 / UIScreen.main.scale
    public var rasterSize: CGFloat = 24.0
    public var backgroundColor: UIColor = .darkGray
    public var separatorInsets: UIEdgeInsets = .zero
    public var controlColor: UIColor = .red
    public var searchBarPlaceholder: String? = "Search For Country"

    public init() {}
}
