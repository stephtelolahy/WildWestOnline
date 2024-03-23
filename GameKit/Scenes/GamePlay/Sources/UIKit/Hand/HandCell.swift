//
//  HandCell.swift
//
//  Created by Hugues Stephano Telolahy on 04/02/2020.
//
// swiftlint:disable no_magic_numbers

import UIKit

class HandCell: UICollectionViewCell {
    // MARK: Outlets

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var cardImageView: UIImageView!

    // MARK: Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 2
    }

    func update(with cardName: String, active: Bool) {
        cardImageView.image = UIImage(named: cardName)
        cardView.isHidden = active
    }
}
