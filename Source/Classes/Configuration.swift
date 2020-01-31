//
//  Configuration.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

public protocol Configuration {
    var textAttributes: [NSAttributedString.Key: Any] { get }
    var textBackgroundColor: UIColor { get }
    var selectionColor: UIColor { get }
    var lineColor: UIColor { get }
    var lineWidth: CGFloat { get }
    var rasterSize: CGFloat { get }
    var backgroundColor: UIColor { get }
    var separatorInsets: UIEdgeInsets { get }
    var controlColor: UIColor { get }
    var searchBarAttributedPlaceholder: NSAttributedString { get }
}
