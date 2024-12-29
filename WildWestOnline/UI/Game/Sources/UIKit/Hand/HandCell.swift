//
//  HandCell.swift
//
//  Created by Hugues Stephano Telolahy on 04/02/2020.
//

import UIKit
import GameCore

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

    func update(with item: GameView.State.HandCard) {
        let cardName = Card.extractName(from: item.card)
        let cardImage = UIImage(named: cardName, in: Bundle.module, with: .none)
        if let cardImage {
            cardImageView.image = cardImage
            abilityLabel.text = nil
        } else {
            abilityLabel.text = item.card
            cardImageView.image = nil
        }

        cardDisabledLayer.isHidden = item.active
    }
}
