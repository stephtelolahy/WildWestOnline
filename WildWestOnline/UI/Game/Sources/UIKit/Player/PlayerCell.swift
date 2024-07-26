//
//  PlayerCell.swift
//
//  Created by Hugues Stephano Telolahy on 24/01/2020.
//
// swiftlint:disable no_magic_numbers

import UIKit
// import Kingfisher

class PlayerCell: UICollectionViewCell {
    @IBOutlet private weak var figureImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var equipmentLabel: UILabel!
    @IBOutlet private weak var roleImageView: UIImageView!
    @IBOutlet private weak var healthLabel: UILabel!
    @IBOutlet private weak var handLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        figureImageView.addBrownRoundedBorder()
    }

    func update(with item: GameView.State.PlayerItem) {
        updateBackground(item)

        nameLabel.text = item.displayName
        figureImageView.alpha = !item.isEliminated ? 1.0 : 0.4
        equipmentLabel.text = item.inPlay.map { "[\($0)]" }.joined(separator: "\n")
        if let role = item.role {
            roleImageView.image = UIImage(named: role)
        } else {
            roleImageView.image = nil
        }
        healthLabel.text = ""
        + Array(item.health..<item.maxHealth).map { _ in "░" }
            + Array(0..<item.health).map { _ in "■" }.joined()
        handLabel.text = "[] \(item.handCount)"

        let figureImage = UIImage(named: item.imageName, in: Bundle.module, with: .none)
        if let figureImage {
            figureImageView.image = figureImage
        } else {
            figureImageView.image = nil
        }

//        if let userPhotoUrl = item.userPhotoUrl {
//            avatarImageView.kf.setImage(with: URL(string: userPhotoUrl))
//        } else {
//            avatarImageView.image = nil
//        }
    }

    private func updateBackground(_ item: GameView.State.PlayerItem) {
        if item.isEliminated {
            backgroundColor = .clear
        } else if item.isTargeted {
            backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        } else if item.isTurn {
            backgroundColor = UIColor.orange
        } else {
            backgroundColor = UIColor.brown.withAlphaComponent(0.4)
        }
    }
}
