//
//  ColumbusMain.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2023 Stefan Herold. All rights reserved.
//

import Foundation

// swiftlint:disable:next convenience_type
public final class ColumbusMain {
    public static let countriesJsonUrl = Bundle.module.url(
        forResource: "Countries",
        withExtension: "json"
    )

    static func layoutConstraintId(_ suffix: String) -> String {
        // swiftlint:disable:next force_unwrapping
        "\(Bundle.module.bundleIdentifier!).\(suffix)"
    }
}
