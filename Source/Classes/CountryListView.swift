//
//  CountryListView.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import SwiftUI

public struct CountryListView: View {
    @ObjectBinding private var store = CountryStore()

    public init() {}

    #warning("Implement a search bar!")
    #warning("Implement an index bar!")
    public var body: some View {
        NavigationView {
            List(store.countries) { country in
                CountryRow(country: country)
            }
            .navigationBarTitle(Text("Countries"))
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
