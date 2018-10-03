//
//  CountryCell.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import UIKit

final class CountryCell: UITableViewCell {

    static let cellId = "\(self.self)"

    var countryView = CountryView()
    private var cachedSize = CGSize.zero

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
        cachedSize = .zero
    }

    func setupCountryView() {
        countryView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countryView)
    }

    func setupLayoutConstraints() {
        let raster = Columbus.config.rasterSize

        NSLayoutConstraint.activate([
            countryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: raster),
            countryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -raster),
            countryView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: raster),
            countryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -raster),
            ]
        )
    }

    func configure(with country: Country) {
        countryView.configure(with: country)
    }
}

