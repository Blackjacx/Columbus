//
//  Configurable.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2022 Stefan Herold. All rights reserved.
//

import UIKit

public protocol Configurable {
    var displayState: CountryPickerViewController.DisplayState { get }
    var textAttributes: [NSAttributedString.Key: Any] { get }
    var textFieldBackgroundColor: UIColor { get }
    var selectionColor: UIColor { get }
    var lineColor: UIColor { get }
    var lineWidth: CGFloat { get }
    var rasterSize: CGFloat { get }
    var backgroundColor: UIColor { get }
    var separatorInsets: NSDirectionalEdgeInsets? { get }
    var controlColor: UIColor { get }
    var searchBarAttributedPlaceholder: NSAttributedString { get }
}
