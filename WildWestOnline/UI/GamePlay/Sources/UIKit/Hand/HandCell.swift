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
    @IBOutlet private weak var abilityLabel: UILabel!

    // MARK: Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 2
    }

    func update(with item: GamePlayView.State.CardAction) {
        let cardName = item.card.extractName()
        let cardImage = UIImage(named: cardName, in: Bundle.module, with: .none)
        if let cardImage {
            cardImageView.image = cardImage
            abilityLabel.text = nil
        } else {
            abilityLabel.text = item.card
            cardImageView.image = nil
        }

        let isActive = item.action != nil
        cardDisabledLayer.isHidden = isActive
    }
}
