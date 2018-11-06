//
//  CountryView.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import UIKit

final class CountryView: UIView {

    let stackView = UIStackView()
    let flagImageView = UIImageView()
    let countryNameLabel = UILabel()
    let countryCodeLabel = UILabel()

    init() {
        super.init(frame: .zero)

        setupStackView()
        setupFlagImageView()
        setupCountryNameLabel()
        setupCountryCodeLabel()
        setupViewLayoutConstraints()
    }

    @available(*, unavailable, message:"init(frame:) has not been implemented")
    private override convenience init(frame: CGRect) {
        fatalError()
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setupStackView() {
        [flagImageView, countryNameLabel, countryCodeLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.spacing = Columbus.config.rasterSize
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }

    func setupFlagImageView() {
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.layer.shadowColor = UIColor.black.cgColor
        flagImageView.layer.shadowOpacity = 0.25
        flagImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.setContentHuggingPriority(.required, for: .horizontal)
    }

    func setupCountryNameLabel() {
        countryNameLabel.textColor = Columbus.config.textColor
        countryCodeLabel.textAlignment = .left
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupCountryCodeLabel() {
        countryCodeLabel.textColor = Columbus.config.textColor
        countryCodeLabel.textAlignment = .right
        countryCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func setupViewLayoutConstraints() {
        let constraints: [NSLayoutConstraint] = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            flagImageView.heightAnchor.constraint(equalToConstant: 16),
            flagImageView.widthAnchor.constraint(equalTo: flagImageView.heightAnchor, multiplier: 4/3),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configure(with country: Country) {
        countryNameLabel.attributedText = NSAttributedString(string: country.name,
                                                             attributes: Columbus.config.textAttributes)
        countryCodeLabel.attributedText = NSAttributedString(string: country.dialingCodeWithPlusPrefix,
                                                             attributes: Columbus.config.textAttributes)
        flagImageView.image = UIImage(named: country.isoCountryCode.lowercased(),
                                      in: Columbus.bundle,
                                      compatibleWith: nil)
    }
}
