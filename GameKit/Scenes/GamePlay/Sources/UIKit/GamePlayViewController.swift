//
//  GamePlayViewController.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//

import UIKit

public class GamePlayViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private weak var endTurnButton: UIButton!
    @IBOutlet private weak var playersCollectionView: UICollectionView!
    @IBOutlet private weak var handCollectionView: UICollectionView!
    @IBOutlet private weak var messageTableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var discardImageView: UIImageView!
    @IBOutlet private weak var deckImageView: UIImageView!
    @IBOutlet private weak var deckCountLabel: UILabel!

    // MARK: - IBAction

    @IBAction private func closeButtonTapped(_ sender: Any) {
    }

    @IBAction private func endTurnTapped(_ sender: Any) {
    }
}
