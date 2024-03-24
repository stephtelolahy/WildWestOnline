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
        // TODO: endTurn
    }
}

private extension GamePlayViewController {
    func setupViews() {
        playersCollectionViewLayout.delegate = self
        playersCollectionView.setCollectionViewLayout(playersCollectionViewLayout, animated: false)
        playersCollectionView.dataSource = self
        playersCollectionView.delegate = self

        handCollectionView.setCollectionViewLayout(handlCollectionViewLayout, animated: false)
        handCollectionView.dataSource = self
        handCollectionView.delegate = self

        messageTableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.className)
        messageTableView.dataSource = self
    }
}

extension GamePlayViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        store.state.events.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MessageCell.self, for: indexPath)
        let item = store.state.events[indexPath.row]
        cell.update(with: item)
        return cell
    }
}

extension GamePlayViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == playersCollectionView {
            return playersCollectionViewNumberOfItems()
        } else {
            return handCollectionViewNumberOfItems()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == playersCollectionView {
            playersCollectionView(collectionView, cellForItemAt: indexPath)
        } else {
            handCollectionView(collectionView, cellForItemAt: indexPath)
        }
    }

    private func playersCollectionViewNumberOfItems() -> Int {
        store.state.players.count
    }

    private func handCollectionViewNumberOfItems() -> Int {
        store.state.handActions.count
    }

    private func playersCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: PlayerCell.self, for: indexPath)
        let item = store.state.players[indexPath.row]
        cell.update(with: item)
        return cell
    }

    private func handCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: HandCell.self, for: indexPath)
        let item = store.state.handActions[indexPath.row]
        cell.update(with: item)
        return cell
    }
}

extension GamePlayViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView == playersCollectionView {
            playersCollectionViewDidSelectItem(at: indexPath)
        } else {
            handCollectionViewDidSelectItem(at: indexPath)
        }
    }

    private func playersCollectionViewDidSelectItem(at indexPath: IndexPath) {
        let player = store.state.players[indexPath.row]
        // TODO: open player description
        //        router.toGamePlayer(player)
    }

    private func handCollectionViewDidSelectItem(at indexPath: IndexPath) {
        guard let action = store.state.handActions[indexPath.row].action else {
            return
        }

        store.dispatch(action)
    }
}

extension GamePlayViewController: PlayerCollectionViewLayoutDelegate {
    func numberOfItemsForGameCollectionViewLayout(layout: PlayerCollectionViewLayout) -> Int {
        store.state.players.count
    }
}
