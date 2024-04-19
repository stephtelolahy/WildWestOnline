//
//  GamePlayViewController.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
// swiftlint:disable type_contents_order

import AppCore
import Combine
import GameCore
import Redux
import UIKit

class GamePlayViewController: UIViewController {
    // MARK: - Data

    private var store: Store<GamePlayUIKitView.State>
    private var subscriptions = Set<AnyCancellable>()
    private var events: [String] = []

    // MARK: - IBOutlets

    @IBOutlet private weak var playersCollectionView: UICollectionView!
    @IBOutlet private weak var handCollectionView: UICollectionView!
    @IBOutlet private weak var messageTableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var discardImageView: UIImageView!
    @IBOutlet private weak var deckImageView: UIImageView!
    @IBOutlet private weak var deckCountLabel: UILabel!

    private let playersCollectionViewLayout = PlayerCollectionViewLayout()
    private let handlCollectionViewLayout = HandCollectionViewLayout()
    private let animationMatcher: AnimationMatcherProtocol = AnimationMatcher()
    private var animationRenderer: AnimationRendererProtocol!
    private var previousState: GamePlayUIKitView.State?

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
        observeState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGame()
    }

    // MARK: - IBAction

    @IBAction private func closeButtonTapped(_ sender: Any) {
        store.dispatch(AppAction.close)
    }
}

private extension GamePlayViewController {
    func startGame() {
        let sheriff = store.state.players[0].id
        store.dispatch(GameAction.setTurn(player: sheriff))
    }

    func setupViews() {
        playersCollectionView.register(
            UINib(nibName: "PlayerCell", bundle: .module),
            forCellWithReuseIdentifier: "PlayerCellIdentifier"
        )
        playersCollectionViewLayout.delegate = self
        playersCollectionView.setCollectionViewLayout(playersCollectionViewLayout, animated: false)
        playersCollectionView.dataSource = self
        playersCollectionView.delegate = self

        handCollectionView.setCollectionViewLayout(handlCollectionViewLayout, animated: false)
        handCollectionView.register(
            UINib(nibName: "HandCell", bundle: .module),
            forCellWithReuseIdentifier: "HandCellIdentifier"
        )
        handCollectionView.dataSource = self
        handCollectionView.delegate = self

        messageTableView.register(
            UINib(nibName: "MessageCell", bundle: .module),
            forCellReuseIdentifier: "MessageCellIdentifier"
        )
        messageTableView.dataSource = self
    }

    func observeState() {
        store.$state.sink { [weak self] state in
            self?.updateViews(with: state)
            self?.previousState = state
        }
        .store(in: &subscriptions)
    }

    func updateViews(with state: GamePlayUIKitView.State) {
        titleLabel.text = state.message
        discardImageView.image = state.topDiscardImage
        deckCountLabel.text = "[] \(state.deckCount)"

        playersCollectionView.reloadData()
        handCollectionView.reloadData()

        if let chooseOneData = state.chooseOneData {
            showChooseOneAlert(chooseOneData, completion: store.dispatch)
        }

        if let event = state.occurredEvent {
            if let animation = animationMatcher.animation(on: event),
               let previousState {
                animationRenderer.execute(animation, from: previousState, to: state)
            }

            events.insert(String(describing: event), at: 0)
            messageTableView.reloadData()
        }
    }

    func showChooseOneAlert(
        _ data: GamePlayUIKitView.State.ChooseOneData,
        completion: @escaping (GameAction) -> Void
    ) {
        let alert = UIAlertController(
            title: "Choose \(data.choiceType.rawValue)",
            message: nil,
            preferredStyle: .alert
        )

        data.actions.forEach { key, action in
            alert.addAction(
                UIAlertAction(
                    title: key,
                    style: .default
                ) { _ in
                    completion(action)
                }
            )
        }

        present(alert, animated: true)
    }

    func showPlayerInfoAlert(_ player: GamePlayUIKitView.State.PlayerItem) {
        let alert = UIAlertController(
            title: player.displayName,
            message: "TODO: description",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Close", style: .cancel)
        )
        present(alert, animated: true)
    }
}

extension GamePlayViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        events.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        // swiftlint:disable:next force_cast line_length
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCellIdentifier", for: indexPath) as! MessageCell
        let item = events[indexPath.row]
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
        // swiftlint:disable:next force_cast line_length
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCellIdentifier", for: indexPath) as! PlayerCell
        let item = store.state.players[indexPath.row]
        cell.update(with: item)
        return cell
    }

    private func handCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast line_length
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HandCellIdentifier", for: indexPath) as! HandCell
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
        showPlayerInfoAlert(player)
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

private extension GamePlayUIKitView.State {
    var topDiscardImage: UIImage? {
        guard let topDiscard else {
            return nil
        }

        let discardCardName = topDiscard.extractName()
        return UIImage(named: discardCardName, in: Bundle.module, with: .none)
    }
}
