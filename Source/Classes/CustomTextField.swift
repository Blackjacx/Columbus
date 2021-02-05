//
//  CustomTextField.swift
//  Columbus
//
//  Created by Stefan Herold on 05.02.21.
//  Copyright © 2021 Stefan Herold. All rights reserved.
//

import UIKit

final class CustomTextField: UITextField {

    private let config: Configurable

    private func sharedInit() {
        adjustsFontForContentSizeCategory = true
        clearButtonMode = .always
    }

    public init(config: Configurable) {
        self.config = config
        super.init(frame: .zero)
        sharedInit()
    }

    public init?(coder aDecoder: NSCoder, config: Configurable) {
        self.config = config
        super.init(coder: aDecoder)
        sharedInit()
    }

    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 4
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).insetBy(dx: config.rasterSize, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds).insetBy(dx: config.rasterSize, dy: 0)
    }
}
