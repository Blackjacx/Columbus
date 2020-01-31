//
//  CountryView.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

final class CountryView: UIView {

    let stackView = UIStackView()
    let flagImageView = UIImageView()
    let countryNameLabel = UILabel()
    let countryCodeLabel = UILabel()

    static func masterInit(instance: CountryView) {
        instance.setupStackView()
        instance.setupFlagImageView()
        instance.setupCountryNameLabel()
        instance.setupCountryCodeLabel()
        instance.setupViewLayoutConstraints()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        Self.masterInit(instance: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Self.masterInit(instance: self)
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
        flagImageView.setContentHuggingPriority(.required, for: .vertical)
    }

    func setupCountryNameLabel() {
        countryCodeLabel.textAlignment = .left
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        countryNameLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupCountryCodeLabel() {
        countryCodeLabel.textAlignment = .right
        countryCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        countryCodeLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    func setupViewLayoutConstraints() {
        let constraints: [NSLayoutConstraint] = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            flagImageView.widthAnchor.constraint(equalTo: flagImageView.heightAnchor, multiplier: 4/3)
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
