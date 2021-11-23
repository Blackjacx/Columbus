//
//  Country.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2021 Stefan Herold. All rights reserved.
//

import UIKit

enum CountryDecodingError: Error {
    case nameNotFound
    case flagIconNotFound
}

public struct Country {

    private static let locale = Locale(identifier: Locale.preferredLanguages.first!)

    /// Name of the country
    public let name: String
    /// ISO country code, e.g. DE, etc.
    public let isoCountryCode: String
    /// International dialing code, e.g. 49, 1, ...
    public let dialingCodeWithPlusPrefix: String
    /// `dialingCode` without + sign
    public let dialingCode: String
    /// The flag icon as unicode string
    public let flagString: String
}

extension Country: Decodable {

    enum CodingKeys: String, CodingKey {
        case isoCountryCode = "code"
        case dialingCodeWithPlusPrefix = "dial_code"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isoCountryCode = try container.decode(String.self, forKey: .isoCountryCode)

        self.isoCountryCode = isoCountryCode
        dialingCodeWithPlusPrefix = try container.decode(String.self, forKey: .dialingCodeWithPlusPrefix)
        dialingCode = dialingCodeWithPlusPrefix.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

        guard let countryName = Self.locale.localizedString(forRegionCode: isoCountryCode) else {
            throw CountryDecodingError.nameNotFound
        }
        name = countryName

        guard let flagString = Self.flagUnicode(isoCountryCode: isoCountryCode, name: countryName) else {
            throw CountryDecodingError.flagIconNotFound
        }
        self.flagString = flagString
    }

    static func flagUnicode(isoCountryCode: String, name: String) -> String? {
        let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        var s = ""
        for v in isoCountryCode.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
