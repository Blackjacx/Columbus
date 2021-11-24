//
//  AppDelegate.swift
//  Columbus_iOS_Example
//
//  Created by Stefan Herold on 23.06.18.
//  Copyright © 2021 Stefan Herold. All rights reserved.
//

import UIKit
import Columbus

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let config = CountryPickerConfig()
        var countryPicker = CountryPickerViewController(config: config, initialCountryCode: "DE") { (country) in
            print("Programmatic: \(country)")
        }

        #if os(iOS)
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "CountryPickerStoryboard", bundle: nil)
            countryPicker = storyboard.instantiateViewController(identifier: "picker") { (coder) -> CountryPickerViewController? in
                CountryPickerViewController(coder: coder, config: config, initialCountryCode: "DE") { (country) in
                    print("Storyboard: \(country)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        #endif

        window?.rootViewController = countryPicker
        window?.makeKeyAndVisible()
        return true
    }
}

struct CountryPickerConfig: Configurable {

    var displayState = CountryPickerViewController.DisplayState.countryCodeSelection
    /// In this example this has to be a computed property so the font object
    /// is calculated later on demand. Since this object is created right at app
    /// start something related to dynamic type seems not to be ready yet.
    var textAttributes: [NSAttributedString.Key: Any] {
        [
            .foregroundColor: UIColor.text,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
    }
    var textFieldBackgroundColor: UIColor = .textFieldBackground
    var backgroundColor: UIColor = .background
    var selectionColor: UIColor = .selection
    var controlColor: UIColor = UIColor(red: 1.0 / 255.0, green: 192.0 / 255.0, blue: 1, alpha: 1)
    var lineColor: UIColor = .line
    var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    var rasterSize: CGFloat = 10.0
    var separatorInsets: NSDirectionalEdgeInsets? { .zero }
    let searchBarAttributedPlaceholder: NSAttributedString = {
        NSAttributedString(string: "Search",
                           attributes: [
                            .foregroundColor: UIColor.placeholder,
                            .font: UIFont.preferredFont(forTextStyle: .body)])
    }()
}
