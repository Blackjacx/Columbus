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
    var config: Configurable!

    private func sharedInit() {
        selectedBackgroundView = UIView()
        selectedBackgroundView?.layer.masksToBounds = true

        backgroundView = UIView()
        backgroundView?.layer.masksToBounds = true

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
         backgroundView?.backgroundColor = isFocused ? config.selectionColor : config.backgroundColor
    }

    func setupCountryView() {
        countryView.translatesAutoresizingMaskIntoConstraints = false
        countryView.setContentHuggingPriority(.required, for: .vertical)
        contentView.addSubview(countryView)
    }

    func setupLayoutConstraints() {
        let leading = countryView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        leading.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).leading")

        let trailing = countryView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        trailing.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).trailing")

        let top = countryView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        top.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).top")

        let bottom = countryView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        bottom.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).bottom")

        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }

    func configure(with country: Country, config: Configurable) {
        self.config = config
        countryView.configure(with: country, config: config)
    }
}
