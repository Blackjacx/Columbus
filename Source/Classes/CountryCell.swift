//
//  CountryCell.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

import UIKit

final class CountryCell: UITableViewCell {

    static var cellId: String { "\(CountryCell.self)" }

    let countryView = CountryView()

    private func sharedInit() {
        selectedBackgroundView = UIView()
        selectedBackgroundView?.layer.masksToBounds = true
        selectedBackgroundView?.backgroundColor = Columbus.config.selectionColor

        backgroundView = UIView()
        backgroundView?.layer.masksToBounds = true
        backgroundView?.backgroundColor = Columbus.config.backgroundColor

        backgroundColor = Columbus.config.backgroundColor

        setupCountryView()
        setupLayoutConstraints()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = frame.height / 4
        selectedBackgroundView?.layer.cornerRadius = radius
        backgroundView?.layer.cornerRadius = radius
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
         backgroundView?.backgroundColor = isFocused ?
            Columbus.config.selectionColor :
            Columbus.config.backgroundColor
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
