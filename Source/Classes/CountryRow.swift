//
//  CountryRow.swift
//  Columbus
//
//  Created by Stefan Herold on 13.07.19.
//  Copyright © 2019 CodingCobra. All rights reserved.
//

import UIKit
import SwiftUI

struct CountryRow : View {
    var country: Country

    #warning("Apply attributes to both text labels: Columbus.config.textAttributes. See [ViewModifiers](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-custom-modifiers)")
    var body: some View {
        let raster = Columbus.config.rasterSize

        return HStack() {
            country.flagIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(color: Color(.shadow), radius: Columbus.config.shadowRadius, x: 1, y: 1)
                .frame(width: Columbus.config.flagWidth, alignment: .leading)
                .padding([.trailing], raster)
                .layoutPriority(1.0)

            Text(country.name)
                .frame(alignment: .leading)
                .foregroundColor(Color(.text))

            Spacer(minLength: raster)

            Text(country.dialingCodeWithPlusPrefix)
                .frame(alignment: .trailing)
                .foregroundColor(Color(.text))
                .layoutPriority(0.5)
        }
    }
}

//#if DEBUG
//struct CountryRow_Previews : PreviewProvider {
//    static var previews: some View {
//        CountryRow()
//    }
//}
//#endif
