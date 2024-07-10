//
//  CountryPickerViewController+DisplayState.swift
//  Columbus
//
//  Created by Stefan Herold on 05.02.21.
//  Copyright © 2023 Stefan Herold. All rights reserved.
//

import UIKit

public extension CountryPickerViewController {

    /// This enum controls how the picker will look like. Features like the searchbar will always be visible.
    enum DisplayState {
        /// Simple, showing only the countries
        case simple
        /// Showing the iso country code too. Suitable when selecting the county code for a phone number.
        case countryCodeSelection
    }
}
