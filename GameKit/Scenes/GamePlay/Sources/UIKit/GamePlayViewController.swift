//
//  GamePlayViewController.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
// swiftlint:disable type_contents_order

import AppCore
import Redux
import UIKit

class GamePlayViewController: UIViewController {
    // MARK: - Data

    private var store: Store<GamePlayUIKitView.State>

    // MARK: - IBOutlets

    @IBOutlet private weak var endTurnButton: UIButton!
    @IBOutlet private weak var playersCollectionView: UICollectionView!
    @IBOutlet private weak var handCollectionView: UICollectionView!
    @IBOutlet private weak var messageTableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var discardImageView: UIImageView!
    @IBOutlet private weak var deckImageView: UIImageView!
    @IBOutlet private weak var deckCountLabel: UILabel!

    private let playersCollectionViewLayout = PlayerCollectionViewLayout()
    private let handlCollectionViewLayout = HandCollectionViewLayout()

    // MARK: - Init

    init(store: Store<GamePlayUIKitView.State>) {
        self.store = store
        super.init(nibName: "GamePlayViewController", bundle: .module)
    }

    // swiftlint:disable:next unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - IBAction

    @IBAction private func closeButtonTapped(_ sender: Any) {
        store.dispatch(AppAction.close)
    }

    @IBAction private func endTurnTapped(_ sender: Any) {
    }
}

private extension GamePlayViewController {
    func setupViews() {
        playersCollectionView.setCollectionViewLayout(playersCollectionViewLayout, animated: false)
        handCollectionView.setCollectionViewLayout(handlCollectionViewLayout, animated: false)
    }
}
