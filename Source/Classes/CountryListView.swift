//
//  CountryListView.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import SwiftUI

public struct CountryListView: View {
    @ObservedObject private var store = CountryStore()
    @State var query: String = ""
    private let raster = Columbus.config.rasterSize

    public init() {
    }

    #warning("Implement a search bar!")
    #warning("Implement an index bar!")
    #warning("Find out how to elegate country to the outside world")
    #warning("Consider distributing the framework as Binary Package so it is not compiled all the time.")

    #warning("Update README.md for SPM/Binary Package and usage instructions.")
    public var body: some View {
        NavigationView {
            VStack(spacing: raster) {
                HStack(spacing: raster) {
                    Image(systemName: "magnifyingglass")

                    TextField(Columbus.config.searchBarPlaceholder, text: $query) {
                        self.store.filter(query: self.query)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(Color(.text))
                }
                .padding()

                List(store.filteredCountries) { country in
                    CountryRow(country: country)
                }
            }
            .navigationBarTitle(Text("Countries"))
        }.onAppear {
            self.store.load()
        }
    }
}

#if DEBUG
struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView()
    }
}
#endif
