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

        let config = DefaultConfig()
        Columbus.config = config

        let countryPicker = CountryPickerViewController(initialRegionCode: "DE", didSelectClosure: { [weak self] (country) in
            print(country)
        })
        window?.rootViewController = countryPicker
        window?.makeKeyAndVisible()
        return true
    }
}
