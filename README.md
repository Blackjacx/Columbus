# Columbus

[![Twitter](https://img.shields.io/twitter/follow/blackjacxxx?label=%40Blackjacxxx)](https://twitter.com/blackjacx)
<a href="https://github.com/Blackjacx/columbus/actions?query=workflow%3ACI"><img alt="CI status" src="https://github.com/blackjacx/columbus/workflows/CI/badge.svg" /></a>
<img alt="Github Current Release" src="https://img.shields.io/github/release/blackjacx/Columbus.svg" /> 
<img alt="Cocoapods Platforms" src="https://img.shields.io/cocoapods/p/Columbus.svg"/>
<img alt="Xcode 12.0+" src="https://img.shields.io/badge/Xcode-12.0%2B-blue.svg"/>
<img alt="iOS 11.0+" src="https://img.shields.io/badge/iOS-11.0%2B-blue.svg"/>
<img alt="Swift 5.3+" src="https://img.shields.io/badge/Swift-5.3%2B-orange.svg"/>
<img alt="Github Repo Size" src="https://img.shields.io/github/repo-size/blackjacx/Columbus.svg" />
<img alt="Github Code Size" src="https://img.shields.io/github/languages/code-size/blackjacx/Columbus.svg" />
<img alt="Github Closed PR's" src="https://img.shields.io/github/issues-pr-closed/blackjacx/Columbus.svg" />
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat"/></a>
<a href="https://github.com/Blackjacx/Columbus/blob/develop/LICENSE?raw=true"><img alt="License" src="https://img.shields.io/cocoapods/l/Columbus.svg?style=flat"/></a>
<a href="https://codebeat.co/projects/github-com-blackjacx-columbus-develop"><img alt="codebeat badge" src="https://codebeat.co/badges/7ad2da62-af22-4a76-a4da-2eb2002bde18" /></a>  
<a href="https://www.paypal.me/STHEROLD"><img alt="Donate" src="https://img.shields.io/badge/Donate-PayPal-blue.svg"/></a>

A country picker for iOS, tvOS ad watchOS with features you will only find distributed in many different country-picker implementations. 

## Features

- Filter countries using an as-you-type search bar - type the **name** or it's **country code**
- Quickly find a country by using the **indexbar** on the right
- Localized by using standard components and Apple's `Locale` class
- Theme support to easily fit to your design
- Storyboard support
- Select a country from the history of selected countries - `still in progress`

## Installation

Columbus is compatible with `iOS 11` and higher and builds with `Xcode 11` and `Swift 5.3+`. 

### Carthage (recommended)

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Columbus into your Xcode project using Carthage, specify it in your Cartfile:

```ruby
github "Blackjacx/Columbus"
```

The use the following command to build the XCFramework:

```shell
carthage bootstrap --use-ssh --use-xcframeworks --cache-builds
```

Using Carthage has some advantages in contrast to Cocopods for this framework. Since it needs to compile the asset catalog for over 200 flag assets it is much faster to build the framework once using Carthage and drop it into your app. If you use Cocoapods the asset catalog is compiled together with Columbus each time you do a clean build and probably also when Xcode thinks Columbus needs to be compiled again.

### CocoaPods

To install via [CocoaPods](https://cocoapods.org/pods/Columbus), simply add the following line to your Podfile and run `pod install` to install the newest version:

```ruby
pod "Columbus"
```

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
    var textFieldBackgroundColor: UIColor = .textFieldBackground
    var backgroundColor: UIColor = .background
    var selectionColor: UIColor = .selection
    var controlColor: UIColor = UIColor(red: 1.0 / 255.0, green: 192.0 / 255.0, blue: 1, alpha: 1)
    var lineColor: UIColor = .line
    var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    var rasterSize: CGFloat = 10.0
    var separatorInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: rasterSize * 4.7, bottom: 0, right: rasterSize * 2.5)
    }
    let searchBarAttributedPlaceholder: NSAttributedString = {
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

Good news for our storyboard users. I implemented full storyboard support - but for iOS 13 only. You'll need a fallback for earlier versions. To instantiate the picker from a storyboard you can use the following example:

```swift
if #available(iOS 13.0, *) {
    let defaultCountry = CountryPickerViewController.defaultCountry(from: "US")
    let picker: CountryPickerViewController = storyboard.instantiateViewController(identifier: "Picker") { (coder) -> CountryPickerViewController? in
        return CountryPickerViewController(configcoder: coder, initialCountryCode: defaultCountry.isoCountryCode) { (country) in
            print(country)
        }
    }
} else {
    // Fallback on earlier versions
}

```

The above example gives you a non-optional instance of `CountryPickerViewController`. This new syntax also enables us to provide parameters for a storyboard-initialized view (controller). This prevents the addition of optional properties like in previous versions of iOS which is a huge progress.

### iOS

The repo includes an example project. It shows the main use case of the project - the country picker. To run it, just type `pod try Columbus` in your console and it will be downloaded and opened for you. The following set of screenshots highlights the key features unique to Columbus:

Filtering|Indexbar|History|Localization|Theming
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

## Links

[Localize the cancel button of a UISearchBar](https://stackoverflow.com/questions/12031942/uisearchbar-cancel-button-change-language-of-word-cancel-in-uisearchdisplaycon)

## Credits

[Thanks for the flag icons](https://github.com/lipis/flag-icon-css)

## License

Columbus is available under the MIT license. See the [LICENSE](LICENSE) file for more info.