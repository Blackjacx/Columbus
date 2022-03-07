//
//  CountryPickerViewController.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2022 Stefan Herold. All rights reserved.
//

import UIKit

#if os(iOS) && !targetEnvironment(simulator)
import CoreTelephony
#endif

/// The CountryPickerViewController class uses a UITableView to display
/// country names, flags and dialling codes. It is used to pick a country.
public final class CountryPickerViewController: UIViewController {

    public typealias DidSelectCountry = (_ country: Country) -> Void

    /// The list of data displayed in the data source
    public static let countries = createCountries()

    /// The configuration for the country picker
    let config: Configurable
    /// The list of data displayed when the user enters a search term
    var filteredItems = CountryList()
    /// Returns all items or filtered items if filtering is currently active
    var items: CountryList { searchbar.isFiltering ? filteredItems : Self.countries }
    /// The data source for the section indexing
    var itemsForSectionTitle = [String: [Country]]()
    /// The section index title cache
    var sectionTitles = [String]()
    /// Called by the CountryPicker after the user selects a country.
    let didSelectClosure: DidSelectCountry
    /// The currently picked iso country code
    let selectedCountryCode: String
    /// The search bar to search for countries
    let searchbar: CustomSearchBar
    /// Offset before search started, so it can be set again afterwards.
    var scrollOffsetPriorSearch = CGPoint.zero
    /// The tableview that displays the countries
    let table = UITableView(frame: .zero, style: .plain)
    /// Constrains the bottom margin of the tableview to screen or keyboard
    var tableViewBottomConstraint: NSLayoutConstraint!
    /// The index path of the currently focussed item
    var focussedIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsFocusUpdate()
                self?.updateFocusIfNeeded()
            }
        }
    }

    override public weak var preferredFocusedView: UIView? {

        print("\(focussedIndexPath.section), \(focussedIndexPath.row)")
        let cell = table.cellForRow(at: focussedIndexPath)
        return cell
    }

    /// The observer that informs about KeyboardDidShow notifications
    private var keyboardDidShowObserver: NSObjectProtocol?
    /// The observer that informs about KeyboardWillHide notifications
    private var keyboardWillHideObserver: NSObjectProtocol?

    // MARK: - Initialization

    public init(config: Configurable,
                initialCountryCode: String,
                didSelectClosure: @escaping DidSelectCountry) {
        self.config = config
        self.searchbar = CustomSearchBar(config: config)
        self.selectedCountryCode = initialCountryCode
        self.didSelectClosure = didSelectClosure
        super.init(nibName: nil, bundle: nil)
    }

    public init?(coder aDecoder: NSCoder,
                 config: Configurable,
                 initialCountryCode: String,
                 didSelectClosure: @escaping DidSelectCountry) {
        self.config = config
        self.searchbar = CustomSearchBar(config: config)
        self.selectedCountryCode = initialCountryCode
        self.didSelectClosure = didSelectClosure
        super.init(coder: aDecoder)
    }

    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    deinit {
        deinitObserver()
    }

    private func deinitObserver() {

        #if os(iOS)
        if let observer = keyboardDidShowObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        if let observer = keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        #endif
    }

    // MARK: - Setup UI

    override public func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = config.backgroundColor

        setupTable()
        #if os(iOS)
        setupSearchbar()
        #endif
        setupAutoLayout()

        reloadData()
        displaySelectedCountry()
        setupObserver()
    }

    private func setupObserver() {

        let center = NotificationCenter.default

        #if os(iOS)
        keyboardDidShowObserver = center.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                                     object: nil,
                                                     queue: nil) { [weak self] (note) in

            guard let userInfo = note.userInfo,
                  userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? Bool == true,
                  let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            self?.tableViewBottomConstraint.constant = -frame.height
        }

        keyboardWillHideObserver = center.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                      object: nil,
                                                      queue: nil) { [weak self] (note) in

            guard let userInfo = note.userInfo, userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? Bool == true else {
                return
            }
            self?.tableViewBottomConstraint.constant = 0
        }
        #endif
    }

    private func setupTable() {
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CountryCell.self, forCellReuseIdentifier: CountryCell.cellId)
        table.backgroundColor = config.backgroundColor
        table.dataSource = self
        table.delegate = self
        table.tintColor = config.controlColor
        table.tableFooterView = UIView()
        view.addSubview(table)
    }

    private func setupSearchbar() {

        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.delegate = self
        searchbar.tintColor = config.controlColor
        searchbar.backgroundColor = config.backgroundColor
        searchbar.textField.returnKeyType = .done
        searchbar.textAttributes = config.textAttributes
        searchbar.placeholder = config.searchBarAttributedPlaceholder

        let textField = searchbar.textField
        textField.tintColor = config.controlColor
        textField.textColor = searchbar.tintColor
        textField.backgroundColor = config.textFieldBackgroundColor

        view.addSubview(searchbar)
    }

    private func setupAutoLayout() {

        var constraints: [NSLayoutConstraint] = []

        tableViewBottomConstraint = table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomConstraint.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).tableView.bottom")
        constraints.append(tableViewBottomConstraint)

        let tableLeading = table.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        tableLeading.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).tableView.leading")
        constraints.append(tableLeading)

        let tableTrailing = table.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        tableTrailing.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).tableView.trailing")
        constraints.append(tableTrailing)

        #if os(iOS)

        let searchbarTop = searchbar.topAnchor.constraint(equalTo: view.topAnchor)
        searchbarTop.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).searchbar.top")
        constraints.append(searchbarTop)

        let searchbarLeading = searchbar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        searchbarLeading.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).searchbar.leading")
        constraints.append(searchbarLeading)

        let searchbarTrailing = searchbar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        searchbarTrailing.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).searchbar.trailing")
        constraints.append(searchbarTrailing)

        let tableTop = table.topAnchor.constraint(equalTo: searchbar.bottomAnchor)
        tableTop.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).tableView.top")
        constraints.append(tableTop)

        #else

        let tableTop = table.topAnchor.constraint(equalTo: view.topAnchor)
        tableTop.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).tableView.top")
        constraints.append(tableTop)

        #endif

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Country Handling

    /// Gives you the default country for your device using the following (ordered) approaches:
    /// 1. Trying to determine your country using the country you passed in via its two-letter ISO country code. This
    /// has precedence since from now it is only used for really forcing the country picker to return a specific
    /// country.
    /// 2. Trying to determine your country from your SIM card
    /// 3. Using `US` as fallback if the other approaches didn't work.
    public static func defaultCountry(from isoCountryCode: String? = nil) -> Country {

        // Using the `isoCountryCode` parameter to force the picker to return a specific country.

        if
            let isoCountryCode = isoCountryCode,
            let country = (countries.first { $0.isoCountryCode.compare(isoCountryCode, options: .caseInsensitive) == .orderedSame }) {
            return country
        }

        // Core Telephony Approach

        #if os(iOS) && !targetEnvironment(simulator)
        if
            let isoCountryCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.isoCountryCode,
            let country = (countries.first { $0.isoCountryCode.compare(isoCountryCode, options: .caseInsensitive) == .orderedSame }) {
            return country
        }
        #endif

        // Fallback  to US

        return countries.first { $0.isoCountryCode.compare("US", options: .caseInsensitive) == .orderedSame }!
    }

    private static func createCountries() -> CountryList {

        guard
            let countriesFilePath = ColumbusMain.bundle.path(forResource: "Countries", ofType: "json"),
            let countriesData = FileManager.default.contents(atPath: countriesFilePath),
            let countries = try? JSONDecoder().decode(CountryList.self, from: countriesData) else {
                return CountryList()
        }
        return countries
    }

    // MARK: - Filtering

    func filterContentForSearchText(_ searchText: String) {
        let filteredByName = Self.countries.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        let filteredByDialingCode = Self.countries.filter {
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

        itemsForSectionTitle = Dictionary(grouping: items) { String($0.name.prefix(1)) }
        sectionTitles = [String](itemsForSectionTitle.keys)
        sectionTitles = sectionTitles.sorted(by: <)
    }

    // MARK: - Date Reloading

    func reloadData() {

        updateSectionIndex()
        table.reloadData()
    }

    // MARK: Pre-select initial country

    func displaySelectedCountry() {

        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard
                let key = (self?.itemsForSectionTitle.first { $0.value.contains { $0.isoCountryCode == self?.selectedCountryCode } }?.key),
                let section = (self?.sectionTitles.firstIndex { $0 == key }),
                let row = (self?.itemsForSectionTitle[key]?.firstIndex { $0.isoCountryCode == self?.selectedCountryCode }) else {

                    return
            }

            let indexPath = IndexPath(row: row, section: section)

            DispatchQueue.main.async { [weak self] in
                #if os(iOS)
                self?.table.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.table.deselectRow(at: indexPath, animated: true)
                }
                #elseif os(tvOS)
                self?.table.scrollToRow(at: indexPath, at: .middle, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.focussedIndexPath = indexPath
                }
                #endif
            }
        }
    }
}

extension CountryPickerViewController: CustomSearchBarDelegate {

    func searchBarTextDidChange(_ searchBar: CustomSearchBar, newText: String) {
        filterContentForSearchText(newText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: CustomSearchBar) {
        scrollOffsetPriorSearch = table.contentOffset
//        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: CustomSearchBar) {
        // Schedule re-setting contentOffset when table view finished reloading
        // https://stackoverflow.com/a/16071589/971329
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.table.setContentOffset(self.scrollOffsetPriorSearch, animated: true)
        }
//        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension CountryPickerViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionTitles[section]
        return itemsForSectionTitle[key]?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.cellId, for: indexPath)
        let raster = config.rasterSize
        let margins = NSDirectionalEdgeInsets(top: raster, leading: raster, bottom: raster, trailing: raster)

        if let cell = cell as? CountryCell {
            let key = sectionTitles[indexPath.section]
            let sectionItems = itemsForSectionTitle[key]
            let item = sectionItems?[indexPath.row]
            item.map { cell.configure(with: $0, config: config) }
        }

        cell.selectedBackgroundView?.backgroundColor = config.selectionColor
        cell.backgroundView?.backgroundColor = config.backgroundColor
        cell.backgroundColor = config.backgroundColor
        cell.contentView.directionalLayoutMargins = margins
        cell.contentView.preservesSuperviewLayoutMargins = false

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
        sectionTitles[section]
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionTitles
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // Adjusting the seperator insets: http://stackoverflow.com/a/39005773/971329

        #if os(iOS)
        // setting seperator inset
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        #endif
    }
}
