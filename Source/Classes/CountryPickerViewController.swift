//
//  CountryPickerViewController.swift
//  Columbus
//
//  Created by Stefan Herold on 22.06.18.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

#if os(iOS) && !targetEnvironment(simulator)
import CoreTelephony
#endif

/// The CountryPickerViewController class uses a UITableView to display
/// country names, flags and dialling codes. It is used to pick a country.
public final class CountryPickerViewController: UIViewController {

    /// The list of data displayed in the data source
    public static let countries = createCountries()
    /// The list of data displayed when the user enters a search term
    var filteredItems = CountryList()
    /// Returns all items or filtered items if filtering is currently active
    var items: CountryList { searchbar.isFiltering ? filteredItems : type(of: self).countries }
    /// The data source for the section indexing
    var itemsForSectionTitle = [String: [Country]]()
    /// The section index title cache
    var sectionTitles = [String]()
    /// Called by the CountryPicker when the user selects a country.
    let didSelectClosure: (_ country: Country) -> ()
    /// The currently picked country
    let selectedRegionCode: String
    /// The search bar to search for countries
    let searchbar = CustomSearchBar()
    /// Offset before search started, so it can be set again afterwards.
    var scrollOffsetPriorSearch = CGPoint.zero
    /// The tableview that displays the countries
    let table = UITableView(frame: .zero, style: .plain)
    /// Constrains the bottom margin of the tableview to screen or keyboard
    var tableViewBottomConstraint: NSLayoutConstraint!
    
    /// The observer that informs about KeyboardWillShow notifications
    private var keyboardDidShowObserver: NSObjectProtocol?
    /// The observer that informs about KeyboardWillHide notifications
    private var keyboardWillHideObserver: NSObjectProtocol?

    // MARK: - Initialization

    public init(initialRegionCode: String, didSelectClosure: @escaping ((_ country: Country) -> ())) {
        self.selectedRegionCode = initialRegionCode
        self.didSelectClosure = didSelectClosure
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message:"init() has not been implemented")
    init() {
        preconditionFailure()
    }

    @available(*, unavailable, message: "init(nibName: , bundle:) has not been implemented")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        preconditionFailure()
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required public init?(coder aDecoder: NSCoder) {
        preconditionFailure()
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

        view.backgroundColor = Columbus.config.backgroundColor

        setupTable()
        #if os(iOS)
        setupSearchbar()
        #endif
        setupLayoutConstraints()

        reloadData()
        displaySelectedCountry()
        setupObserver()
    }

    private func setupObserver() {
        
        #if os(iOS)
        keyboardDidShowObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil) { [weak self] (note) in
            guard let userInfo = note.userInfo else { return }
            guard let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
            self?.tableViewBottomConstraint.constant = -height
        }
        
        keyboardWillHideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] (_) in
            self?.tableViewBottomConstraint.constant = 0
        }
        #endif
    }
    
    private func setupTable() {
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CountryCell.self, forCellReuseIdentifier: CountryCell.cellId)
        table.backgroundColor = Columbus.config.backgroundColor
        table.dataSource = self
        table.delegate = self
        table.tintColor = Columbus.config.controlColor
        table.tableFooterView = UIView()
        view.addSubview(table)
    }

    private func setupSearchbar() {

        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.delegate = self
        searchbar.tintColor = Columbus.config.controlColor
        searchbar.backgroundColor = Columbus.config.backgroundColor
        searchbar.textAttributes = Columbus.config.textAttributes
        searchbar.placeholder = Columbus.config.searchBarAttributedPlaceholder

        let textField = searchbar.textField
        textField.tintColor = Columbus.config.controlColor
        textField.textColor = searchbar.tintColor
        textField.backgroundColor = Columbus.config.textFieldBackgroundColor

        view.addSubview(searchbar)
    }

    private func setupLayoutConstraints() {

        var constraints: [NSLayoutConstraint] = []

        tableViewBottomConstraint = table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomConstraint.identifier = Columbus.layoutConstraintId("\(type(of: self)).tableView.bottom")
        constraints.append(tableViewBottomConstraint)

        let tableLeading = table.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        tableLeading.identifier = Columbus.layoutConstraintId("\(type(of: self)).tableView.leading")
        constraints.append(tableLeading)

        let tableTrailing = table.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        tableTrailing.identifier = Columbus.layoutConstraintId("\(type(of: self)).tableView.trailing")
        constraints.append(tableTrailing)

        #if os(iOS)

        let searchbarTop = searchbar.topAnchor.constraint(equalTo: view.topAnchor)
        searchbarTop.identifier = Columbus.layoutConstraintId("\(type(of: self)).searchbar.top")
        constraints.append(searchbarTop)

        let searchbarLeading = searchbar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        searchbarLeading.identifier = Columbus.layoutConstraintId("\(type(of: self)).searchbar.leading")
        constraints.append(searchbarLeading)

        let searchbarTrailing = searchbar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        searchbarTrailing.identifier = Columbus.layoutConstraintId("\(type(of: self)).searchbar.trailing")
        constraints.append(searchbarTrailing)

        let tableTop = table.topAnchor.constraint(equalTo: searchbar.bottomAnchor)
        tableTop.identifier = Columbus.layoutConstraintId("\(type(of: self)).tableView.top")
        constraints.append(tableTop)

        #else

        let tableTop = table.topAnchor.constraint(equalTo: view.topAnchor)
        tableTop.identifier = Columbus.layoutConstraintId("\(type(of: self)).tableView.top")
        constraints.append(tableTop)
        
        #endif

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Country Handling

    public static func defaultCountry(for locale: Locale = Locale.current) -> Country {

        // Core Telephony Approach

        #if os(iOS) && !targetEnvironment(simulator)
        if
            let simRegionId = CTTelephonyNetworkInfo().subscriberCellularProvider?.isoCountryCode,
            let country = (countries.first { $0.isoCountryCode.compare(simRegionId, options: .caseInsensitive) == .orderedSame }) {
            return country
        }
        #endif

        // Current Locale Approach

        if let country = (countries.first { $0.isoCountryCode == locale.regionCode }) {
            return country
        }

        // Default

        return countries.filter { $0.isoCountryCode.compare("de", options: .caseInsensitive) == .orderedSame }[0]
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
        let filteredByName = type(of: self).countries.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        let filteredByDialingCode = type(of: self).countries.filter {
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
        table.reloadData()
    }

    // MARK: Pre-select initial country

    func displaySelectedCountry() {

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard
                let key = (self?.itemsForSectionTitle.first { $0.value.contains { $0.isoCountryCode == self?.selectedRegionCode } }?.key),
                let section = (self?.sectionTitles.firstIndex { $0 == key }),
                let row = (self?.itemsForSectionTitle[key]?.firstIndex { $0.isoCountryCode == self?.selectedRegionCode }) else {

                    return
            }

            let indexPath = IndexPath(row: row, section: section)

            DispatchQueue.main.async { [weak self] in
                self?.table.selectRow(at: indexPath, animated: true, scrollPosition: .middle)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                    self?.table.deselectRow(at: indexPath, animated: true)
                })
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
        sectionTitles[section]
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionTitles
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // Adjusting the seperator insets: http://stackoverflow.com/a/39005773/971329

        #if os(iOS)
        // removing seperator inset
        cell.separatorInset = Columbus.config.separatorInsets
        #endif

        // prevent the cell from inheriting the tableView's margin settings
        cell.preservesSuperviewLayoutMargins = false

        // explicitly setting cell's layout margins
        cell.layoutMargins = Columbus.config.separatorInsets
    }
}
