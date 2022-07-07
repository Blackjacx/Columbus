//
//  CountryView.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2022 Stefan Herold. All rights reserved.
//

import UIKit

final class CountryView: UIView {

    private (set) lazy var leadingTextAnchor: NSLayoutXAxisAnchor = countryNameLabel.leadingAnchor
    private (set) lazy var trailingTextAnchor: NSLayoutXAxisAnchor = countryCodeLabel.trailingAnchor

    private let hStack = UIStackView()
    private let flagIconView = UILabel()
    private let countryNameLabel = UILabel()
    private let countryCodeLabel = UILabel()

    var country: Country!
    var config: Configurable!

    private func sharedInit() {
        setupHStack()
        setupFlagIconView()
        setupCountryNameLabel()
        setupCountryCodeLabel()
        setupAutoLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func setupHStack() {
        [flagIconView, countryNameLabel, countryCodeLabel].forEach {
            hStack.addArrangedSubview($0)
        }
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
    }

    func setupFlagIconView() {
        flagIconView.numberOfLines = 1
        flagIconView.setContentHuggingPriority(.required, for: .horizontal)
        flagIconView.setContentHuggingPriority(.required, for: .vertical)
        flagIconView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func setupCountryNameLabel() {
    }

    private func setupCountryCodeLabel() {
        countryCodeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        countryCodeLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    func setupAutoLayout() {
        let constraints: [NSLayoutConstraint] = [
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configure(with country: Country, config: Configurable) {

        hStack.spacing = config.rasterSize

        countryNameLabel.attributedText = NSAttributedString(string: country.name,
                                                             attributes: config.textAttributes)

        let countryCodeAttributes = updatedAttributes(attributes: config.textAttributes,
                                                      alignment: .right)
        countryCodeLabel.attributedText = NSAttributedString(string: country.dialingCodeWithPlusPrefix,
                                                             attributes: countryCodeAttributes)

        let flagIconAttributes = updatedAttributes(attributes: config.textAttributes,
                                                   // Ensure a system font is used for the emojis so they are not
                                                   // truncated or rendered in a weird way
                                                   font: UIFont.preferredFont(forTextStyle: .body),
                                                   // Center icon horizontally (tvOS)
                                                   alignment: .center,
                                                   // Improve visibility of flags with white background
                                                   shadow: NSShadow())

        flagIconView.attributedText = NSAttributedString(string: country.flagString,
                                                         attributes: flagIconAttributes)

        // Configure Display State
        switch config.displayState {
        case .simple:                   countryCodeLabel.isHidden = true
        case .countryCodeSelection:     countryCodeLabel.isHidden = false
        }
    }

    private func updatedAttributes(attributes: [NSAttributedString.Key: Any],
                                   font: UIFont? = nil,
                                   alignment: NSTextAlignment? = nil,
                                   shadow: NSShadow? = nil) -> [NSAttributedString.Key: Any] {
        var attributes = attributes

        if let font = font {
            attributes[.font] = font
        }

        if let alignment = alignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.setParagraphStyle(NSParagraphStyle.default)
            paragraphStyle.alignment = alignment
            attributes[.paragraphStyle] = paragraphStyle
        }

        if let shadow = shadow {
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            shadow.shadowColor = UIColor(white: 0, alpha: 0.25)
            attributes[.shadow] = shadow
        }

        return attributes
    }
}
