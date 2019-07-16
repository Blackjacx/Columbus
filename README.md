<!-- <p align="center">
<img src="./icon.png" alt="Columbus" height="128" width="128">
</p> -->

<h1 align="center">Columbus</h1>

<p align="center">
  <a href="https://app.bitrise.io/build/ddeb8a6c0cf9a616">
    <img alt="Build Status" src="https://app.bitrise.io/app/f12f3f1a861800f0/status.svg?token=yxLmeCg3EaFOFnZKhbHGrQ&branch=develop"/>
  </a>
  <img alt="Github Current Release" src="https://img.shields.io/github/release/blackjacx/Columbus.svg" /> 
  <img alt="Platforms" src="https://img.shields.io/cocoapods/p/Columbus.svg"/>
  <img alt="Xcode 11.0+" src="https://img.shields.io/badge/Xcode-11.0%2B-blue.svg"/>
  <img alt="iOS 13.0+" src="https://img.shields.io/badge/iOS-13.0%2B-blue.svg"/>
  <img alt="Swift 5.1" src="https://img.shields.io/badge/swift-5.1-FFAC45.svg"/>
  <a href="https://github.com/apple/swift-package-manager">
    <img src="https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg" alt="SwiftPM: Compatible">
  </a>
  <img alt="Github Repo Size" src="https://img.shields.io/github/repo-size/blackjacx/Columbus.svg" />
  <img alt="Github Code Size" src="https://img.shields.io/github/languages/code-size/blackjacx/Columbus.svg" />
  <a href="https://github.com/Blackjacx/Columbus/pulls?q=is%3Apr+is%3Aclosed">
    <img alt="Github Closed PR's" src="https://img.shields.io/github/issues-pr-closed/blackjacx/Columbus.svg" />
  </a> 
  <a href="https://github.com/Carthage/Carthage">
    <img alt="Carthage Compatible" src="https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat"/>
  </a>
  <a href="https://cocoapods.org/pods/Columbus">
      <img src="https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat" alt="CocoaPods Compatible">
    </a>
  <a href="https://github.com/Blackjacx/Columbus/blob/develop/LICENSE?raw=true">
    <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg" alt="License MIT">
  </a>
  <a href="https://codebeat.co/projects/github-com-blackjacx-columbus-develop">
    <img alt="codebeat badge" src="https://codebeat.co/badges/7ad2da62-af22-4a76-a4da-2eb2002bde18" />
  </a>
  <a href="https://twitter.com/blackjacxxx"><img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/blackjacxxx?label=%40Blackjacxxx"/></a>
  <a href="https://www.paypal.me/STHEROLD"><img alt="Donate" src="https://img.shields.io/badge/Donate-PayPal-blue.svg"/></a>
</p>

A country picker for iOS, tvOS ad watchOS with features you will only find distributed in many different country-picker implementations. The following list highlights the most valuable features:
- Filter countries by using the searchbar
- Quickly find a country by using the indexbar on the right side
- Select a country from the history of selected countries - `still in progress`
- Localized by using standard components and Apple's `Locale` class
- Theming support to easily match your design

## Installation

Columbus 2.x is implemented using SwiftUI and therefore only compatible with `iOS 13` and higher. It builds with `Xcode 11` and `Swift 5.1`.  

If you need to support iOS 11/12 please use Columbus version 1.x.

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

Using Carthage has some advantages in contrast to Cocopods for this framework. Since it needs to compile the asset catalog for over 200 flag assets it is much faster to build the framework once using Carthage and hard-integrate it into your app. If you use Cocoapods the asset catalog is compiled together with Columbus each time you do a clean build and probably also when Xcode thinks Columbus needs to be compiled again.

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
