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
    public var textColor: UIColor = .darkGray
    public var textAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15)]
    public var lineColor: UIColor = .lightGray
    public var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    public var rasterSize: CGFloat = 12.0
    public var backgroundColor: UIColor = .white
    public var separatorInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: rasterSize * 3.7, bottom: 0, right: rasterSize)
    }
    public var controlColor: UIColor = UIColor(red: 1.0/255.0, green: 192.0/255.0, blue: 1, alpha: 1)
    public var searchBarPlaceholder: String? = "Search"

    public init() {}
}
