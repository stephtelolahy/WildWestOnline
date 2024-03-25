//
//  HandCell.swift
//
//  Created by Hugues Stephano Telolahy on 04/02/2020.
//
// swiftlint:disable no_magic_numbers

import UIKit

class HandCell: UICollectionViewCell {
    // MARK: Outlets

    @IBOutlet private weak var cardDisabledLayer: UIView!
    @IBOutlet private weak var cardImageView: UIImageView!

    // MARK: Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 2
    }

    func update(with item: GamePlayUIKitView.State.CardAction) {
        cardImageView.image = UIImage(named: item.card)
        cardDisabledLayer.isHidden = item.action != nil
    }
}
