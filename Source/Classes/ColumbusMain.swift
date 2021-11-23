//
//  ColumbusMain.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2021 Stefan Herold. All rights reserved.
//

import Foundation

// swiftlint:disable:next convenience_type
public final class ColumbusMain {

    public static let bundle: Bundle = {
        let frameworkBundle = Bundle(for: ColumbusMain.self)
        let bundleName = "Resources.bundle"
        guard let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent(bundleName) else {
            preconditionFailure("Bundle url nil!")
        }
        guard let bundle = Bundle(url: bundleURL) else {
            preconditionFailure("Bundle nil!")
        }
        return bundle
    }()

    static func layoutConstraintId(_ suffix: String) -> String {
        "\(ColumbusMain.bundle.bundleIdentifier!).\(suffix)"
    }
}
