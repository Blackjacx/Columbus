//
//  CountryStore.swift
//  Columbus
//
//  Created by Stefan Herold on 14.07.19.
//  Copyright © 2019 CodingCobra. All rights reserved.
//

import SwiftUI
import Combine

final class CountryStore: ObservableObject {

    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []

    init() {}

    func filter(query: String) {
        let filteredByName = self.countries.filter {
            $0.name.lowercased().contains(query.lowercased())
        }
        let filteredByDialingCode = self.countries.filter {
            "+\($0.dialingCode)".contains(query)
        }

        if !filteredByName.isEmpty {
            self.filteredCountries = filteredByName
        } else {
            self.filteredCountries = filteredByDialingCode
        }
    }

    func load() {
        guard
            let filePath = Columbus.bundle.path(forResource: "Countries", ofType: "json"),
            let data = FileManager.default.contents(atPath: filePath),
            let countries = try? JSONDecoder().decode(CountryList.self, from: data).countries else {
                return
        }
        self.countries = countries
        self.filteredCountries = countries
    }
}

private struct CountryList: Decodable {

    var countries: [Country]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var countries: [Country] = []

        while !container.isAtEnd {
            do {
                let country = try container.decode(Country.self)
                countries.append(country)
            } catch {
                // Container index increments only after successful decode 
                _ = try? container.decode(EmptyResponse.self)
                print(error)
            }
        }
        self.countries = countries
            .sorted { $1.name > $0.name }
    }
}

private struct EmptyResponse: Decodable {}
