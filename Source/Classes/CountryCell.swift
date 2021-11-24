//
//  CountryCell.swift
//  Columbus
//
//  Created by Stefan Herold on 21.06.18.
//  Copyright © 2021 Stefan Herold. All rights reserved.
//

import UIKit

final class CountryCell: UITableViewCell {

    static var cellId: String { "\(CountryCell.self)" }

    private let countryView = CountryView()
    private let separator = UIView()
    private var config: Configurable!

    private var separatorHeight: NSLayoutConstraint?
    private var separatorLeading: NSLayoutConstraint?
    private var separatorTrailing: NSLayoutConstraint?

    private func sharedInit() {
        selectedBackgroundView = UIView()
        selectedBackgroundView?.layer.masksToBounds = true

        backgroundView = UIView()
        backgroundView?.layer.masksToBounds = true

        setupCountryView()
        setupSeparator()
        setupAutoLayout()
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

    private func setupSeparator() {
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
    }

    func setupAutoLayout() {
        separatorHeight = separator.heightAnchor.constraint(equalToConstant: 0)
        separatorHeight?.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).separatorHeight")

        let separatorBottom = separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        separatorBottom.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).separatorBottom")

        let leading = countryView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        leading.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).leading")

        let trailing = countryView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        trailing.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).trailing")

        let top = countryView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        top.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).top")

        let bottom = countryView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        bottom.identifier = ColumbusMain.layoutConstraintId("\(type(of: self)).bottom")

        NSLayoutConstraint.activate([
            leading,
            trailing,
            top,
            bottom,
            separatorHeight!,
            separatorBottom
        ])
    }

    func configure(with country: Country, config: Configurable) {
        self.config = config
        countryView.configure(with: country, config: config)

        //
        // Separator setup
        //

        separator.backgroundColor = config.lineColor
        separatorHeight?.constant = config.lineWidth

        // First deactivate constraints
        NSLayoutConstraint.deactivate([separatorLeading, separatorTrailing].compactMap { $0 })

        // Now override constraints
        if let separatorInsets = config.separatorInsets {
            separatorLeading = separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: separatorInsets.leading)
            separatorTrailing = separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: separatorInsets.trailing)
        } else {
            separatorLeading = separator.leadingAnchor.constraint(equalTo: countryView.leadingTextAnchor)
            separatorTrailing = separator.trailingAnchor.constraint(equalTo: countryView.trailingTextAnchor)
        }
        // Finally activate the correct constraints
        NSLayoutConstraint.activate([separatorLeading!, separatorTrailing!])

        #if os(iOS)
        separator.isHidden = false
        #else
        separator.isHidden = true
        #endif
    }
}
