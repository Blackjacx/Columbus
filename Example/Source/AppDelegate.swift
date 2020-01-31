//
//  AppDelegate.swift
//  Columbus_Example_TV
//
//  Created by Stefan Herold on 23.06.18.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit
import Columbus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let config = CountryPickerConfig()
        Columbus.config = config

        let countryPicker = CountryPickerViewController(initialRegionCode: "DE", didSelectClosure: { (country) in
            print(country)
        })
        window?.rootViewController = countryPicker
        window?.makeKeyAndVisible()
        return true
    }
}

public struct CountryPickerConfig: Configuration {

    public var textAttributes: [NSAttributedString.Key: Any] = {
        let textColor: UIColor

        if #available(iOS 13.0, *) { textColor = .label
        } else { textColor = .systemGray }

        return [
            .foregroundColor: textColor,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
    }()

    public var textBackgroundColor: UIColor {
        if #available(iOS 13.0, *) { return .systemGray6
        } else { return .lightGray }
    }

    public var selectionColor: UIColor {
        if #available(iOS 13.0, *) { return .systemGray5
        } else { return UIColor(white: 0.9, alpha: 1.0) }
    }

    public var lineColor: UIColor {
        if #available(iOS 13.0, *) { return .opaqueSeparator
        } else { return .lightGray }
    }

    public var lineWidth: CGFloat = 1.0 / UIScreen.main.scale

    public var rasterSize: CGFloat = 10.0

    public var backgroundColor: UIColor {
        if #available(iOS 13.0, *) { return .systemBackground
        } else { return .white }
    }

    public var separatorInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: rasterSize * 3.7, bottom: 0, right: rasterSize)
    }

    public var controlColor: UIColor = UIColor(red: 1.0/255.0, green: 192.0/255.0, blue: 1, alpha: 1)

    public let searchBarAttributedPlaceholder: NSAttributedString = {
        let textColor: UIColor

        if #available(iOS 13.0, *) { textColor = .placeholderText
        } else { textColor = .systemGray }

        return NSAttributedString(string: "Search",
                                  attributes: [
                                    .foregroundColor: textColor,
                                    .font: UIFont.preferredFont(forTextStyle: .body)
        ])
    }()

    public init() {}
}
