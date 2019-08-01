//
//  CountryListView.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import SwiftUI

public struct CountryListView: View {
    @ObservedObject private var store: CountryStore
    @EnvironmentObject var viewModel: CountryListViewModel
    private let raster = Columbus.config.rasterSize

    public init(store: CountryStore) {
        self.store = store
    }

    #warning("Initially show button to present/dismiss Columbus")
    #warning("Find out how to delegate country to the outside world - Environment!")
    #warning("Consider distributing the framework as Binary Package so it is not compiled all the time.")

    #warning("Update README.md for SPM/Binary Package and usage instructions.")
    #warning("Implement an index bar!")
    public var body: some View {

        return NavigationView {
            VStack(spacing: raster) {
                HStack(spacing: raster) {
                    Image(systemName: "magnifyingglass")

                    TextField(Columbus.config.searchBarPlaceholder, text: $viewModel.query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(Color(.text))
                }
                .padding()

                Text("SelectedCountry: \(self.viewModel.selectedCountry?.name ?? "none")")

                List(self.viewModel.filteredCountries) { country in
                    ZStack {
                        CountryRow(country: country)
                        Button("", action: {
                            self.viewModel.selectedCountry = country
                        })
                    }
                }
            }
            .navigationBarTitle(Text("Countries"))
        }.onAppear {
            self.viewModel.filteredCountries = self.store.countries
        }
    }
}

#if DEBUG
struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView(store: CountryStore())
    }
}
#endif
