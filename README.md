<!-- <p align="center">
<img src="./icon.png" alt="Columbus" height="128" width="128">
</p> -->

<h1 align="center">Columbus</h1>

<p align="center">
  <a href="https://github.com/Blackjacx/columbus/actions?query=workflow%3ACI">
    <img alt="CI status" src="https://github.com/blackjacx/columbus/workflows/CI/badge.svg" />
  </a>

  <img alt="Github Current Release" src="https://img.shields.io/github/release/blackjacx/Columbus.svg" /> 
  <img alt="Cocoapods Platforms" src="https://img.shields.io/cocoapods/p/Columbus.svg"/>
  <img alt="Xcode 11.0+" src="https://img.shields.io/badge/Xcode-11.0%2B-blue.svg"/>
  <img alt="iOS 11.0+" src="https://img.shields.io/badge/iOS-11.0%2B-blue.svg"/>
  <img alt="Swift 5.0+" src="https://img.shields.io/badge/Swift-5.0%2B-orange.svg"/>
  <img alt="Github Repo Size" src="https://img.shields.io/github/repo-size/blackjacx/Columbus.svg" />
  <img alt="Github Code Size" src="https://img.shields.io/github/languages/code-size/blackjacx/Columbus.svg" />
  <img alt="Github Closed PR's" src="https://img.shields.io/github/issues-pr-closed/blackjacx/Columbus.svg" />
  <a href="https://github.com/Carthage/Carthage">
    <img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat"/>
  </a>
  <a href="https://github.com/Blackjacx/Columbus/blob/develop/LICENSE?raw=true">
    <img alt="License" src="https://img.shields.io/cocoapods/l/Columbus.svg?style=flat"/>
  </a>
  <a href="https://codebeat.co/projects/github-com-blackjacx-columbus-develop">
    <img alt="codebeat badge" src="https://codebeat.co/badges/7ad2da62-af22-4a76-a4da-2eb2002bde18" />
  </a>
  <a href="https://twitter.com/blackjacxxx"><img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/blackjacxxx?label=%40Blackjacxxx"/></a>
  <a href="https://www.paypal.me/STHEROLD"><img alt="Donate" src="https://img.shields.io/badge/Donate-PayPal-blue.svg"/></a>
</p>

A country picker for iOS, tvOS ad watchOS with features you will only find distributed in many different country-picker implementations. The following list highlights the most valuable features:
- Filter countries using an as-you-type search bar
- Quickly find a country by using the indexbar on the right
- Select a country from the history of selected countries - `still in progress`
- Localized by using standard components and Apple's `Locale` class
- Theme support to easily fit to your design

## Installation

Columbus is compatible with `iOS 11` and higher and builds with `Xcode 11` and `Swift 5.0+`. 

### CocoaPods

To install via [CocoaPods](https://cocoapods.org/pods/Columbus), simply add the following line to your Podfile and run `pod install` to install the newest version:

```ruby
pod "Columbus"
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Columbus into your Xcode project using Carthage, specify it in your Cartfile:

```ruby
github "Blackjacx/Columbus"
```

Using Carthage has some advantages in contrast to Cocopods for this framework. Since it needs to compile the asset catalog for over 200 flag assets it is much faster to build the framework once using Carthage and drop it into your app. If you use Cocoapods the asset catalog is compiled together with Columbus each time you do a clean build and probably also when Xcode thinks Columbus needs to be compiled again.

## Examples

### Usage

In the following example you'll find all the possible configuration/theming options of Columbus:

```swift
struct CountryPickerConfig: Configuration {

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
    var controlColor: UIColor = UIColor(red: 1.0/255.0, green: 192.0/255.0, blue: 1, alpha: 1)
    var lineColor: UIColor = .line
    var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    var rasterSize: CGFloat = 10.0
    var separatorInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: rasterSize * 3.7, bottom: 0, right: rasterSize)
    }
    let searchBarAttributedPlaceholder: NSAttributedString = {
        NSAttributedString(string: "Search",
                           attributes: [
                            .foregroundColor: UIColor.placeholder,
                            .font: UIFont.preferredFont(forTextStyle: .body)])
    }()
}

Columbus.config = CountryPickerConfig()

let countryPicker = CountryPickerViewController(initialRegionCode: "DE", didSelectClosure: { [weak self] (country) in
    print(country)
})
present(countryPicker, animated: true)

```

### Storyboards

Good news for our storyboard users. I implemented full storyboard support - but for iOS 13 only. You'll need a fallback for earlier versions. To instantiate the picker from a storyboard you can use the following example:

```swift
if #available(iOS 13.0, *) {
    let picker: CountryPickerViewController = storyboard.instantiateViewController(identifier: "Picker") { (coder) -> CountryPickerViewController? in
        return CountryPickerViewController(coder: coder, initialRegionCode: "DE") { (country) in
            print(country)
        }
    }
} else {
    // Fallback on earlier versions
}

```

The above example gives you a non-optional instance of `CountryPickerViewController`. This new syntax also enables us to provide parameters for a storyboard-initialized view (controller). This prevents the addition of optional properties like in previous versions of iOS which is a huge progress.

### iOS

The repo includes an example project. It shows the main use case of the project - the country picker. To run it, just type `pod try Columbus` in your console and it will be downloaded and opened for you. The following set of screenshots highlights the features unique to Columbus:

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