//
//  CustomSearchBar.swift
//  Columbus
//
//  Created by Stefan Herold on 31.01.20.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

protocol CustomSearchBarDelegate: class {
    func searchBarTextDidChange(_ searchBar: CustomSearchBar, newText: String)
    func searchBarTextDidBeginEditing(_ searchBar: CustomSearchBar)
    func searchBarTextDidEndEditing(_ searchBar: CustomSearchBar)
//    func searchBarCancelButtonClicked(_ searchBar: CustomSearchBar)
}

final class CustomSearchBar: UIView {

    private static let textFieldMinHeight: CGFloat = 36

    let textField: UITextField = CustomTextField()
    weak var delegate: CustomSearchBarDelegate?

    private let hStack = UIStackView()

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

    static func masterInit(_ instance: CustomSearchBar) {
        instance.setupHStack()
        instance.setupTextField()
        instance.setupAutoLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        Self.masterInit(self)
        textField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Self.masterInit(self)
        textField.addTarget(self, action: #selector(textDidChange(textField:)), for: .editingChanged)
    }

    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
        return super.resignFirstResponder()
    }

    private func setupHStack() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = Columbus.config.rasterSize
        addSubview(hStack)
    }

    private func setupTextField() {
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.required, for: .vertical)
        textField.delegate = self
        hStack.addArrangedSubview(textField)
    }

    private func setupAutoLayout() {
        let raster = Columbus.config.rasterSize
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: raster/2, leading: raster, bottom: raster/2, trailing: raster)

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
        textField.invalidateIntrinsicContentSize()
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

final class CustomTextField: UITextField {

    static func masterInit(_ instance: CustomTextField) {
        instance.adjustsFontForContentSizeCategory = true
        instance.clearButtonMode = .always
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        Self.masterInit(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Self.masterInit(self)
    }

    override var intrinsicContentSize: CGSize {
        guard let text = text, !text.isEmpty else {
            // You can return some custom size in case of empty string
            return super.intrinsicContentSize
        }
        // Convert to NSString to use size(attributes:)
        let string = text as NSString
        // Calculate size for current text
        let size = string.size(withAttributes: defaultTextAttributes)
        return size
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 4
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory !=
            traitCollection.preferredContentSizeCategory {
            invalidateIntrinsicContentSize()
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).insetBy(dx: Columbus.config.rasterSize, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds).insetBy(dx: Columbus.config.rasterSize, dy: 0)
    }
}
