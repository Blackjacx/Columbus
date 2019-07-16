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
    #warning("Find out how to elegate country to the outside world")
    #warning("Consider distributing the framework as Binary Package so it is not compiled all the time.")

    #warning("Update README.md for SPM/Binary Package and usage instructions.")
    public var body: some View {
        NavigationView {
            List(store.countries) { country in
                CountryRow(country: country).tapAction {
                    print(country)
                }
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
