//
//  CustomSearchBar.swift
//  Columbus
//
//  Created by Stefan Herold on 31.01.20.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

protocol CustomSearchBarDelegate: AnyObject {
    func searchBarTextDidChange(_ searchBar: CustomSearchBar, newText: String)
    func searchBarTextDidBeginEditing(_ searchBar: CustomSearchBar)
    func searchBarTextDidEndEditing(_ searchBar: CustomSearchBar)
//    func searchBarCancelButtonClicked(_ searchBar: CustomSearchBar)
}

final class CustomSearchBar: UIView {

    private static let textFieldMinHeight: CGFloat = 36
    weak var delegate: CustomSearchBarDelegate?

    let textField: UITextField
    private let hStack = UIStackView()
    private let config: Configurable

    var textAttributes: [NSAttributedString.Key: Any] = [:] {
        didSet {
            textField.defaultTextAttributes = textAttributes
            textField.typingAttributes = textAttributes
        }
    }

    /// The current text of the search bar
    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    /// The placeholder of the text search bar
    var placeholder: NSAttributedString {
        get { textField.attributedPlaceholder ?? NSAttributedString() }
        set { textField.attributedPlaceholder = newValue }
    }

    /// Returns `true` if searchbar is first responder and has text
    var isFiltering: Bool {
        textField.isFirstResponder && !text.isEmpty
    }

    private func sharedInit() {
        setupHStack()
        setupTextField()
        setupAutoLayout()
        textField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
    }

    public init(config: Configurable) {
        self.config = config
        self.textField = CustomTextField(config: config)
        super.init(frame: .zero)
        sharedInit()
    }

    public init?(coder aDecoder: NSCoder, config: Configurable) {
        self.config = config
        self.textField = CustomTextField(config: config)
        super.init(coder: aDecoder)
        sharedInit()
    }

    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
        return super.resignFirstResponder()
    }

    private func setupHStack() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = config.rasterSize
        addSubview(hStack)
    }

    private func setupTextField() {
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.required, for: .vertical)
        textField.delegate = self
        hStack.addArrangedSubview(textField)
    }

    private func setupAutoLayout() {
        let raster = config.rasterSize
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: raster / 2,
                                                           leading: raster,
                                                           bottom: raster / 2,
                                                           trailing: raster)

        let constraints: [NSLayoutConstraint] = [
            hStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: Self.textFieldMinHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension CustomSearchBar: UITextFieldDelegate {

    @objc func textDidChange(textField: UITextField) {
        delegate?.searchBarTextDidChange(self, newText: text)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidBeginEditing(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidEndEditing(self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
}
