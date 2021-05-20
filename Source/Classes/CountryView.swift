//
//  CountryView.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

final class CountryView: UIView {

    let hStack = UIStackView()
    let flagImageView = UIImageView()
    let countryNameLabel = UILabel()
    let countryCodeLabel = UILabel()

    var country: Country!
    var config: Configurable!

    private func sharedInit() {
        setupHStack()
        setupFlagImageView()
        setupCountryNameLabel()
        setupCountryCodeLabel()
        setupViewLayoutConstraints()
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
        [flagImageView, countryNameLabel, countryCodeLabel].forEach {
            hStack.addArrangedSubview($0)
        }
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
    }

    func setupFlagImageView() {
        flagImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.layer.shadowColor = UIColor.black.cgColor
        flagImageView.layer.shadowOpacity = 0.25
        flagImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        flagImageView.setContentHuggingPriority(.required, for: .horizontal)
        flagImageView.setContentHuggingPriority(.required, for: .vertical)
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

    func setupViewLayoutConstraints() {
        let constraints: [NSLayoutConstraint] = [
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            flagImageView.widthAnchor.constraint(equalTo: flagImageView.heightAnchor, multiplier: 4 / 3)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configure(with country: Country, config: Configurable) {

        countryNameLabel.attributedText = NSAttributedString(string: country.name, attributes: config.textAttributes)
        countryCodeLabel.attributedText = NSAttributedString(string: country.dialingCodeWithPlusPrefix, attributes: config.textAttributes)

        hStack.spacing = config.rasterSize

        flagImageView.image = UIImage(named: country.isoCountryCode.lowercased(), in: ColumbusMain.bundle, compatibleWith: nil)

        // Configure Display State
        switch config.displayState {
        case .simple:
            countryCodeLabel.isHidden = true
        case .countryCodeSelection:
            countryCodeLabel.isHidden = false
        }
    }
}
