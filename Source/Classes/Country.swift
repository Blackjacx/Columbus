//
//  Country.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import SwiftUI

enum CountryDecodingError: Error {
    case countryNameNotFound(isoCountryCode: String)
    case countryFlagNotFound(isoCountryCode: String)
}

public struct Country: Identifiable {

    /// Confirmance to `Identifiable`
    public var id = UUID()
    /// Name of the country
    public let name: String
    /// ISO country code, e.g. DE, etc.
    public let isoCountryCode: String
    /// International dialing code, e.g. +49, +1, ...
    public let dialingCodeWithPlusPrefix: String
    /// `dialingCode` without + sign
    public let dialingCode: String
    /// The flag icon of the country
    public let flagIcon: Image
}

extension Country: Decodable {

    enum CodingKeys: String, CodingKey {
        case isoCountryCode = "code"
        case dialingCodeWithPlusPrefix = "dial_code"
    }

    public init(from decoder: Decoder) throws {
        let bundle = Columbus.bundle
        let container = try decoder.container(keyedBy: CodingKeys.self)

        isoCountryCode = try container.decode(String.self, forKey: .isoCountryCode)
        dialingCodeWithPlusPrefix = try container.decode(String.self, forKey: .dialingCodeWithPlusPrefix)
        dialingCode = dialingCodeWithPlusPrefix.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

        guard let countryName = Locale.current.localizedString(forRegionCode: isoCountryCode) else {
            throw CountryDecodingError.countryNameNotFound(isoCountryCode: isoCountryCode)
        }

        let imageName = isoCountryCode.lowercased()

        // Checks if image can be loaded since `Image` just crashes
        guard let uiImage = UIImage(named: imageName, in: bundle, compatibleWith: nil) else {
            throw CountryDecodingError.countryFlagNotFound(isoCountryCode: isoCountryCode)
        }
        name = countryName
        flagIcon = Image(uiImage: uiImage)
    }
}
