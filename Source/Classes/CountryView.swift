//
//  CountryView.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2021 Stefan Herold. All rights reserved.
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
        flagIconView.adjustsFontForContentSizeCategory = true
        flagIconView.numberOfLines = 1
        flagIconView.setContentHuggingPriority(.required, for: .horizontal)
        flagIconView.setContentHuggingPriority(.required, for: .vertical)
        flagIconView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func setupCountryNameLabel() {
        countryNameLabel.textAlignment = .left
        countryNameLabel.adjustsFontForContentSizeCategory = true
        countryNameLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupCountryCodeLabel() {
        countryCodeLabel.textAlignment = .right
        countryCodeLabel.adjustsFontForContentSizeCategory = true
        countryCodeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        countryCodeLabel.setContentHuggingPriority(.required, for: .vertical)
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

        countryNameLabel.attributedText = NSAttributedString(string: country.name,
                                                             attributes: config.textAttributes)
        countryCodeLabel.attributedText = NSAttributedString(string: country.dialingCodeWithPlusPrefix,
                                                             attributes: config.textAttributes)

        hStack.spacing = config.rasterSize

        var attributes = config.textAttributes

        // Improve visibility of flags with white background
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        shadow.shadowColor = UIColor(white: 0, alpha: 0.25)
        attributes[.shadow] = shadow

        // Center icon horizontally (tvOS)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(NSParagraphStyle.default)
        paragraphStyle.alignment = .center
        attributes[.paragraphStyle] = paragraphStyle

        flagIconView.attributedText = NSAttributedString(string: country.flagString,
                                                         attributes: attributes)

        // Configure Display State
        switch config.displayState {
        case .simple:                   countryCodeLabel.isHidden = true
        case .countryCodeSelection:     countryCodeLabel.isHidden = false
        }
    }
}
