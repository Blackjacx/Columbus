//
//  CountryCell.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

final class CountryCell: UITableViewCell {

    static var cellId: String { return "\(CountryCell.self)" }

    var countryView = CountryView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView()
        selectedBackgroundView?.layer.cornerRadius = 12.0
        selectedBackgroundView?.layer.masksToBounds = true
        selectedBackgroundView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        backgroundView = UIView()
        backgroundView?.layer.cornerRadius = 12.0
        backgroundView?.layer.masksToBounds = true
        backgroundView?.backgroundColor = Columbus.config.backgroundColor

        backgroundColor = Columbus.config.backgroundColor

        setupCountryView()
        setupLayoutConstraints()
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
         backgroundView?.backgroundColor = isFocused ? .green : Columbus.config.backgroundColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setupCountryView() {
        countryView.translatesAutoresizingMaskIntoConstraints = false
        countryView.setContentHuggingPriority(.required, for: .vertical)
        contentView.addSubview(countryView)
    }

    func setupLayoutConstraints() {
        let raster = Columbus.config.rasterSize

        let leading = countryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: raster)
        leading.identifier = Columbus.layoutConstraintId("\(type(of: self)).leading")

        let trailing = countryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -raster)
        trailing.identifier = Columbus.layoutConstraintId("\(type(of: self)).trailing")

        let top = countryView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: raster)
        top.identifier = Columbus.layoutConstraintId("\(type(of: self)).top")

        let bottom = countryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -raster)
        bottom.identifier = Columbus.layoutConstraintId("\(type(of: self)).bottom")

        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }

    func configure(with country: Country) {
        countryView.configure(with: country)
    }
}

