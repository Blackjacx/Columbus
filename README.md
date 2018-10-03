<!-- <p align="center">
<img src="./icon.png" alt="Columbus" height="128" width="128">
</p> -->

<h1 align="center">Columbus</h1>

<p align="center">
  <a href="https://app.bitrise.io/build/ddeb8a6c0cf9a616">
    <img alt="Build Status" src="https://app.bitrise.io/app/f12f3f1a861800f0/status.svg?token=yxLmeCg3EaFOFnZKhbHGrQ&branch=develop"/>
  </a>
  <img alt="Github Current Release" src="https://img.shields.io/github/release/blackjacx/Columbus.svg" /> 
  <img alt="Cocoapods Platforms" src="https://img.shields.io/cocoapods/p/Columbus.svg"/>
  <img alt="Xcode 10.0+" src="https://img.shields.io/badge/Xcode-10.0%2B-blue.svg"/>
  <img alt="iOS 11.0+" src="https://img.shields.io/badge/iOS-11.0%2B-blue.svg"/>
  <img alt="Swift 4.2+" src="https://img.shields.io/badge/Swift-4.2%2B-orange.svg"/>
  <img alt="Github Repo Size" src="https://img.shields.io/github/repo-size/blackjacx/Columbus.svg" />
  <img alt="Github Code Size" src="https://img.shields.io/github/languages/code-size/blackjacx/Columbus.svg" />
  <img alt="Github Closed PR's" src="https://img.shields.io/github/issues-pr-closed/blackjacx/Columbus.svg" />
  <!-- <a href="https://github.com/Carthage/Carthage">
    <img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat"/>
  </a> -->
  <a href="https://github.com/Blackjacx/Columbus/blob/develop/LICENSE?raw=true">
    <img alt="License" src="https://img.shields.io/cocoapods/l/Columbus.svg?style=flat"/>
  </a>
  <a href="https://codecov.io/gh/Blackjacx/Columbus">
    <img src="https://codecov.io/gh/Blackjacx/Columbus/branch/develop/graph/badge.svg" />
  </a>
  <a href="https://codebeat.co/projects/github-com-blackjacx-columbus-develop">
    <img alt="codebeat badge" src="https://codebeat.co/badges/7ad2da62-af22-4a76-a4da-2eb2002bde18" />
  </a>
  <a href="https://cocoapods.org/pods/Columbus">
    <img alt="Downloads" src="https://img.shields.io/cocoapods/dt/Columbus.svg?maxAge=3600&style=flat" />
  </a>
  <a href="https://www.paypal.me/STHEROLD">
    <img alt="Donate" src="https://img.shields.io/badge/Donate-PayPal-blue.svg"/>
  </a>
</p>

A country picker for iOS, tvOS ad watchOS with features you will only find distributed in many different country-picker implementations. The following list highlights the most valuable features:
- Filter countries by using the searchbar
- Quickly find a country by using the indexbar on the right side
- Select a country from the history of selected countries - `still in progress`
- Localized by using standard components and Apple's `Locale` class
- Theming support to easily match your design

## Installation

### CocoaPods

Columbus is compatible with `iOS 11` and higher and builds with `Xcode 10` and `Swift 4.2`. It is available through [CocoaPods](https://cocoapods.org/pods/Columbus). To install it, simply add the following line to your Podfile and it will install the newest version:

```ruby
pod "Columbus"
```

## Examples

### Usage

```swift
let config = DefaultConfig()
Columbus.config = config

let countryPicker = CountryPickerViewController(initialRegionCode: "DE", didSelectClosure: { [weak self] (country) in
    print(country)
})
present(countryPicker, animated: true)

```

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

[Stefan Herold](mailto:stefan.herold@gmail.com) • [@Blackjacxxx](https://twitter.com/Blackjacxxx)

## Links

[Localize the cancel button of a UISearchBar](https://stackoverflow.com/questions/12031942/uisearchbar-cancel-button-change-language-of-word-cancel-in-uisearchdisplaycon)

## Credits

[Thanks For The Flag Icons](https://github.com/lipis/flag-icon-css)

## License

Columbus is available under the MIT license. See the LICENSE file for more info.
