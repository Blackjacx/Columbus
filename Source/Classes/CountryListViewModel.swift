//
//  CountryListViewModel.swift
//  Columbus-iOS
//
//  Created by Stefan Herold on 01.08.19.
//  Copyright © 2019 CodingCobra. All rights reserved.
//

import SwiftUI
import Combine

/// Advances in Networking 1: https://developer.apple.com/videos/play/wwdc2019/712/?time=705
/// https://www.reddit.com/r/SwiftUI/comments/c5wi5w/throttledebounce_binding/
/// https://github.com/Dimillian/MovieSwiftUI/blob/7ed177d18f83406c80ca7367a2e2fb3f73b9f156/MovieSwift/MovieSwift/binding/SearchTextBinding.swift
public final class CountryListViewModel: ObservableObject {

    private var store: CountryStore

    @Published var filteredCountries: [Country] = []
    @Published var selectedCountry: Country? = nil
    var query: String = "" {
        willSet {
            DispatchQueue.main.async {
                self.searchSubject.send(newValue)
            }
        }
        didSet {
            DispatchQueue.main.async {
                self.onUpdateText(text: self.query)
            }
        }
    }


    private let searchSubject = PassthroughSubject<String, Never>()

    private var searchCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    deinit {
        searchCancellable?.cancel()
    }

    public init(store: CountryStore) {
        self.store = store
        
        searchCancellable = searchSubject
            .eraseToAnyPublisher().map { $0 }
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
//            .throttle(for: 0.3, scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
//            .filter { !$0.isEmpty }
            .sink(receiveValue: { (searchText) in
                self.filteredCountries = self.store.filtered(by: searchText)
                self.onUpdateTextDebounced(text: searchText)
            })
    }


    /// Overwrite by your subclass to get instant text update.
    func onUpdateText(text: String) {

    }

    /// Overwrite by your subclass to get debounced text update.
    func onUpdateTextDebounced(text: String) {
    }
}
