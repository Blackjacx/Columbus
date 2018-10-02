//
//  AppDelegate.swift
//  Columbus_Example_TV
//
//  Created by Stefan Herold on 23.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import UIKit
import Columbus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        var config = DefaultConfig()
        config.searchBarPlaceholder = "搜索"
        Columbus.config = config

        let countryPicker = CountryPickerViewController(initialRegionCode: "DE", didSelectClosure: { [weak self] (country) in
            let alert = UIAlertController(title: country.name, message: "Phone Code: \(country.dialingCodeWithPlusPrefix)\nISO Code: \(country.isoCountryCode)", preferredStyle: .alert)
            self?.window?.rootViewController?.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
                    self?.window?.rootViewController?.dismiss(animated: true, completion: nil)
                })
            })
        })
        window?.rootViewController = countryPicker
        window?.makeKeyAndVisible()
        return true
    }
}
