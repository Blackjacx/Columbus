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

    #warning("Apply attributes to both text labels: Columbus.config.textAttributes")
    #warning("Find out how to prevent truncation for dialing code label")
    var body: some View {
        return HStack(spacing: Columbus.config.rasterSize) {
            country.flagIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(color: Color(.shadow), radius: Columbus.config.shadowRadius, x: 1, y: 1)
                .frame(width: Columbus.config.flagWidth, alignment: .leading)

            Text(country.name)
                .color(Color(.text))
                .frame(alignment: .leading)

            Spacer()

            Text(country.dialingCodeWithPlusPrefix)
                .color(Color(.text))
                .frame(alignment: .trailing)
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
