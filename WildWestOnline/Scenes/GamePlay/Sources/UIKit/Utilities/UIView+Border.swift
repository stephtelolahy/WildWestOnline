//
//  UIView+Border.swift
//
//  Created by Hugues Stéphano TELOLAHY on 01/05/2021.
//
// swiftlint:disable no_magic_numbers

import UIKit

extension UIView {
    func addBrownRoundedBorder() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.brown.cgColor
        layer.borderWidth = 4
        clipsToBounds = true
    }
}
