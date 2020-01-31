//
//  Columbus.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import Foundation

public final class Columbus {

    public static var config: Configuration!
    public static let bundle: Bundle = {
        let frameworkBundle = Bundle(for: Columbus.self)
        let bundleName = "Resources.bundle"
        guard let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(bundleName) else {
            fatalError("Bundle url nil!")
        }
        guard let bundle = Bundle(url: bundleURL) else {
            fatalError("Bundle nil!")
        }
        return bundle
    }()

    static func layoutConstraintId(_ suffix: String) -> String {
        return "\(Columbus.bundle.bundleIdentifier!).\(suffix)"
    }
}
