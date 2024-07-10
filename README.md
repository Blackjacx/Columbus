<!-- [![Test](https://github.com/Blackjacx/Columbus/actions/workflows/test.yml/badge.svg)](https://github.com/Blackjacx/Columbus/actions/workflows/test.yml) -->
<!-- [![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/) -->
[![Twitter Follow](https://img.shields.io/badge/follow-%40blackjacx-1DA1F2?logo=twitter&style=for-the-badge)](https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fgithub.com%2Fblackjacx&screen_name=Blackjacxxx)
[![Github Current Release](https://img.shields.io/github/release/blackjacx/Columbus.svg)](https://github.com/Blackjacx/Columbus/releases)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FBlackjacx%2FColumbus%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Blackjacx/Columbus)
[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FBlackjacx%2FColumbus%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Blackjacx/Columbus)
[![iOS 14+](https://img.shields.io/badge/iOS-13.0%2B-blue.svg)](https://developer.apple.com/download/)
[![Xcode 15+](https://img.shields.io/badge/Xcode-13%2B-blue.svg)](https://developer.apple.com/download/)
[![Codebeat](https://codebeat.co/badges/7ad2da62-af22-4a76-a4da-2eb2002bde18)](https://codebeat.co/projects/github-com-blackjacx-columbus-develop)
[![License](https://img.shields.io/github/license/blackjacx/columbus.svg)](https://github.com/blackjacx/columbus/blob/main/LICENSE)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg?logo=paypal&style=for-the-badge)](https://www.paypal.me/STHEROLD)

# Columbus

A country picker 🌎 for iOS, tvOS ad watchOS with features you will only find distributed in many different country-picker implementations. 

## Features

- Filter countries using an as-you-type search bar - type the **name** or it's **country code**
- Quickly find a country by using the **index bar** on the right
- Localized by using standard components and Apple's `Locale` class
- Theme support to easily fit to your design
- Storyboard support
- Select a country from the history of selected countries - `still in progress`

## Code Documentation

Find the statically generated code documentation [here](https://swiftpackageindex.com/Blackjacx/Columbus) under `Documentation`.

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

In Xcode open your target list and select your project. Click the tab `Swift  Packages` and there the small `+` icon. Enter the URL of this repository, select the version you want to install - usually the preset is okay - and confirm.

## Examples

### Usage

In the following example you'll find all the possible configuration/theming options of Columbus:

```swift
struct CountryPickerConfig: Configurable {

    var displayState = CountryPickerViewController.DisplayState.countryCodeSelection
    /// In this example this has to be a computed property so the font object
    /// is calculated later on demand. Since this object is created right at app
    /// start something related to dynamic type seems not to be ready yet.
    var textAttributes: [NSAttributedString.Key: Any] {
        [
            .foregroundColor: UIColor.text,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
    }
    var searchTextAttributes: [NSAttributedString.Key: Any]? {
        textAttributes
    }
    var backgroundColor: UIColor = .background
    var selectionColor: UIColor = .selection
    var controlColor: UIColor = UIColor(red: 1.0 / 255.0, green: 192.0 / 255.0, blue: 1, alpha: 1)
    var lineColor: UIColor = .line
    var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    var rasterSize: CGFloat = 10.0
    var separatorInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: rasterSize * 4.7, bottom: 0, right: rasterSize * 2.5)
    }
    let searchBarAttributedPlaceholder: NSAttributedString? = {
        NSAttributedString(string: "Search",
                           attributes: [
                            .foregroundColor: UIColor.placeholder,
                            .font: UIFont.preferredFont(forTextStyle: .body)])
    }()
}
let countryPicker = CountryPickerViewController(config: CountryPickerConfig(),
                                                initialCountryCode: "US") { (country) in
    print(country)
}
present(countryPicker, animated: true)

```

### Storyboards

Good news for our storyboard users. I implemented full storyboard support. You'll need a fallback for earlier versions. To instantiate the picker from a storyboard you can use the following example:

```swift
let defaultCountry = CountryPickerViewController.defaultCountry(from: "US")
let picker: CountryPickerViewController = storyboard.instantiateViewController(identifier: "Picker") { (coder) -> CountryPickerViewController? in
    return CountryPickerViewController(coder: coder, initialCountryCode: defaultCountry.isoCountryCode) { (country) in
        print(country)
    }
}
```

The above example gives you a non-optional instance of `CountryPickerViewController`. This new syntax also enables us to provide parameters for a storyboard-initialized view (controller). This prevents the addition of optional properties like in previous versions of iOS which is a huge progress.

### iOS

The repository includes an example project. It shows the main use case of the project - the country picker. To run it, just open its project file and build. The following set of screenshots highlights the key features unique to Columbus:

Filtering|Index bar|History|Localization|Theming
--- | --- | --- | --- | ---
![Searchbar](./github/assets/searchbar.png)|![Indexbar](./github/assets/indexbar.png)|![History](./github/assets/history.png)|![Localization](./github/assets/localization.png)|![Theming](./github/assets/theming.png) 


### tvOS
... still in progress ...

### watchOS
... still in progress ...

## Contribution

- If you found a **bug**, please open an **issue**.
- If you have a **feature request**, please open an **issue**.
- If you want to **contribute**, please submit a **pull request**.

## Author

[Stefan Herold](mailto:stefan.herold@gmail.com) • 🐦 [@Blackjacxxx](https://twitter.com/Blackjacxxx)

## Contributors

Thanks to all of you who are part of this:

<a href="https://github.com/blackjacx/Columbus/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=blackjacx/Columbus" />
</a>

## Links

- [Modifying UISearchBar Cancel button font text color and style](https://stackoverflow.com/questions/11572372/modifying-uisearchbar-cancel-button-font-text-color-and-style)
- [Localize the cancel button of a UISearchBar](https://stackoverflow.com/questions/12031942/uisearchbar-cancel-button-change-language-of-word-cancel-in-uisearchdisplaycon)

## License

Columbus is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
