//
//  Columbus.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import Foundation

public final class Columbus {

    public static var config: Configuration!
    public static let bundle: Bundle = {
        let frameworkBundle = Bundle(for: Columbus.self)
        let bundleName = "Columbus.bundle"
        guard let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(bundleName) else {
            fatalError("Bundle url nil!")
        }
        guard let bundle = Bundle(url: bundleURL) else {
            fatalError("Bundle nil!")
        }
        return bundle
    }()
}
