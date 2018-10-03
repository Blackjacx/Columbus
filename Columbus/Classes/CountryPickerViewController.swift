//
//  CountryPickerViewController.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import UIKit
#if os(iOS)
import CoreTelephony
#endif

/// The CountryPickerViewController class uses a UITableView to display
/// country names, flags and dialling codes. It is used to pick a country.
public final class CountryPickerViewController: UIViewController {

    /// The list of data displayed in the data source
    let allItems = createCountries()
    /// The list of data displayed when the user enters a search term
    var filteredItems = CountryList()
    /// Returns all items or filtered items if filtering is currently active
    var items: CountryList { return isFiltering ? filteredItems : allItems }
    /// The data source for the section indexing
    var itemsForSectionTitle = [String: [Country]]()
    /// The section index title cache
    var sectionTitles = [String]()
    /// Called by the CountryPicker when the user selects a country.
    let didSelectClosure: (_ country: Country) -> ()
    /// The currently picked country
    let selectedRegionCode: String
    #if os(iOS)
    /// The parent view for the searchbar
    let searchBarContentView = UIView()
    /// The search bar to search for countries
    let searchBar = UISearchBar()
    /// Returns `true` if searchbar is first responder and has text
    var isFiltering: Bool { return searchBar.isFirstResponder && !isSearchBarEmpty }
    /// Returns if search bar is empty or not
    var isSearchBarEmpty: Bool { return searchBar.text?.isEmpty ?? true }
    #else
    /// Returns always false on non-iOS platforms
    var isFiltering: Bool = false
    #endif
    /// Offset before search started, so it can be set again afterwards.
    var scrollOffsetPriorSearch = CGPoint.zero
    /// The tableview that displays the countries
    let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Initialization

    public init(initialRegionCode: String, didSelectClosure: @escaping ((_ country: Country) -> ())) {
        self.selectedRegionCode = initialRegionCode
        self.didSelectClosure = didSelectClosure
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message:"init() has not been implemented")
    init() {
        fatalError()
    }

    @available(*, unavailable, message: "init(nibName: , bundle:) has not been implemented")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }


    // MARK: - Setup UI

    override public func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = Columbus.config.backgroundColor

        setupListView()
        setupSearchBar()
        setupLayoutConstraints()

        reloadData()
        displaySelectedCountry()
    }
    
    private func setupListView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.cellId)
        tableView.backgroundColor = Columbus.config.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tintColor = Columbus.config.controlColor
        view.addSubview(tableView)
    }

    private func setupSearchBar() {
        #if os(iOS)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.tintColor = Columbus.config.controlColor
        searchBar.barTintColor = Columbus.config.backgroundColor
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = Columbus.config.searchBarPlaceholder

        let svs = searchBar.subviews.flatMap { $0.subviews }
        guard let textField = (svs.compactMap { $0 as? UITextField }).first else { return }
        textField.textColor = searchBar.tintColor

        searchBarContentView.addSubview(searchBar)

        searchBarContentView.translatesAutoresizingMaskIntoConstraints = false
        searchBarContentView.backgroundColor = searchBar.barTintColor
        view.addSubview(searchBarContentView)
        #endif
    }

    private func setupLayoutConstraints() {
        var constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        #if os(iOS)
        constraints += [
            tableView.topAnchor.constraint(equalTo: searchBarContentView.bottomAnchor),

            searchBarContentView.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            searchBar.topAnchor.constraint(equalTo: searchBarContentView.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchBarContentView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchBarContentView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchBarContentView.safeAreaLayoutGuide.bottomAnchor),
        ]
        #else
        constraints += [
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        #endif

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Country Handling

    public func defaultCountry(for locale: Locale = Locale.current) -> Country {

        // Core Telephony Approach

        #if os(iOS)
        if
            let simRegionId = CTTelephonyNetworkInfo().subscriberCellularProvider?.isoCountryCode,
            let country = (allItems.first { $0.isoCountryCode.compare(simRegionId, options: .caseInsensitive) == .orderedSame }) {
            return country
        }
        #endif

        // Current Locale Approach

        if let country = (allItems.first { $0.isoCountryCode == locale.regionCode }) {
            return country
        }

        // Default

        return allItems.filter { $0.isoCountryCode.compare("de", options: .caseInsensitive) == .orderedSame }[0]
    }

    private static func createCountries() -> CountryList {

        guard
            let countriesFilePath = Columbus.bundle.path(forResource: "Countries", ofType: "json"),
            let countriesData = FileManager.default.contents(atPath: countriesFilePath),
            let countries = try? JSONDecoder().decode(CountryList.self, from: countriesData) else {
                return CountryList()
        }
        return countries
    }

    // MARK: - Filtering

    func filterContentForSearchText(_ searchText: String) {
        let filteredByName = allItems.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        let filteredByDialingCode = allItems.filter {
            "+\($0.dialingCode)".contains(searchText)
        }

        if !filteredByName.isEmpty {
            filteredItems = CountryList(values: filteredByName)
        } else {
            filteredItems = CountryList(values: filteredByDialingCode)
        }
        reloadData()
    }

    // MARK: Section Indices

    func updateSectionIndex() {

        sectionTitles.removeAll()
        itemsForSectionTitle.removeAll()
        
        items.forEach {
            let key = String($0.name.prefix(1))
            guard itemsForSectionTitle[key] != nil else {
                itemsForSectionTitle[key] = [$0]
                return
            }
            itemsForSectionTitle[key]?.append($0)
        }

        sectionTitles = [String](itemsForSectionTitle.keys)
        sectionTitles = sectionTitles.sorted(by: <)
    }

    // MARK: - Date Reloading

    func reloadData() {

        updateSectionIndex()
        tableView.reloadData()
    }

    // MARK: Pre-select initial country

    func displaySelectedCountry() {

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard
                let key = (self?.itemsForSectionTitle.first { $0.value.contains { $0.isoCountryCode == self?.selectedRegionCode } }?.key),
                let section = (self?.sectionTitles.index { $0 == key }),
                let row = (self?.itemsForSectionTitle[key]?.index { $0.isoCountryCode == self?.selectedRegionCode }) else {

                    return
            }

            let indexPath = IndexPath(row: row, section: section)

            DispatchQueue.main.async { [weak self] in
                self?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                    self?.tableView.deselectRow(at: indexPath, animated: true)
                })
            }
        }
    }
}

#if os(iOS)
extension CountryPickerViewController: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        filterContentForSearchText("")
        searchBar.resignFirstResponder()
    }

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        scrollOffsetPriorSearch = tableView.contentOffset
        searchBar.setShowsCancelButton(true, animated: true)
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.contentOffset = scrollOffsetPriorSearch
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
#endif

extension CountryPickerViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionTitles[section]
        return itemsForSectionTitle[key]?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.cellId, for: indexPath)
        if let cell = cell as? CountryCell {
            let key = sectionTitles[indexPath.section]
            let sectionItems = itemsForSectionTitle[key]
            let item = sectionItems?[indexPath.row]
            item.map { cell.configure(with: $0) }
        }
        return cell
    }
}

extension CountryPickerViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = sectionTitles[indexPath.section]
        let sectionItems = itemsForSectionTitle[key]
        let item = sectionItems?[indexPath.row]
        item.map { didSelectClosure($0) }
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
}
