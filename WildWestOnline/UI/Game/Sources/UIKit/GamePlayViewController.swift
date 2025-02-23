//
//  GamePlayViewController.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//
// swiftlint:disable type_contents_order no_magic_numbers force_unwrapping

import Combine
import AppCore
import GameCore
import Redux
import UIKit

class GamePlayViewController: UIViewController {
    // MARK: Constant

    enum Constant {
        static let cardRatio: CGFloat = 250.0 / 389.0
        static let cardBackImageName = "card_back"
    }

    // MARK: - Data

    private var store: Store<GameView.State, Void>
    private var subscriptions: Set<AnyCancellable> = []
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
    private let handlCollectionViewLayout = HandCollectionViewLayout(cardRatio: Constant.cardRatio)
    private let animationMatcher: AnimationMatcherProtocol = AnimationMatcher()
    private lazy var animationRenderer: AnimationRendererProtocol = AnimationRenderer(config: self)

    private var previousState: GameView.State?

    // MARK: - Init

    init(store: Store<GameView.State, Void>) {
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
        Task {
            await store.dispatch(GameAction.startTurn(player: store.state.startPlayer))
        }
    }

    // MARK: - IBAction

    @IBAction private func closeButtonTapped(_ sender: Any) {
        Task {
            await store.dispatch(SetupGameAction.quitGame)
        }
    }
}

private extension GamePlayViewController {
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

        store.eventPublisher.sink { [weak self] event in
            if let gameAction = event as? GameAction {
                self?.updateViews(with: gameAction)
            }
        }
        .store(in: &subscriptions)
    }

    func updateViews(with state: GameView.State) {
        titleLabel.text = state.message
        discardImageView.image = state.topDiscardImage
        deckCountLabel.text = "[] \(state.deckCount)"

        playersCollectionView.reloadData()
        handCollectionView.reloadData()

        if let chooseOne = state.chooseOne {
            showChooseOneAlert(chooseOne) { [weak self] option in
                guard let self,
                      let player = store.state.controlledPlayer else {
                    return
                }

                Task {
                    await self.store.dispatch(GameAction.choose(option, player: player))
                }
            }
        }
    }

    func updateViews(with event: GameAction) {
        let state = store.state
        if let animation = animationMatcher.animation(on: event),
           let previousState {
            animationRenderer.execute(
                animation,
                from: previousState,
                to: state,
                duration: state.animationDelay
            )
        }

        events.insert(String(describing: event), at: 0)
        messageTableView.reloadData()
    }

    func showChooseOneAlert(
        _ data: GameView.State.ChooseOne,
        completion: @escaping (String) -> Void
    ) {
        let alert = UIAlertController(
            title: "Choose \(data.choiceType)",
            message: nil,
            preferredStyle: .actionSheet
        )

        data.options.forEach { key in
            let alertAction = UIAlertAction(
                title: key,
                style: .default
            ) { _ in
                completion(key)
            }
            let image = UIImage(
                named: Card.extractName(from: key),
                in: Bundle.module,
                with: .none
            )?.scale(newWidth: 32)

            alertAction.setValue(
                image?.withRenderingMode(.alwaysOriginal),
                forKey: "image"
            )

            alert.addAction(alertAction)
        }

        present(alert, animated: true)
    }

    func showPlayerInfoAlert(_ player: GameView.State.PlayerItem) {
        let alert = UIAlertController(
            title: player.displayName,
            message: "Description",
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
        // swiftlint:disable:next force_cast
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
        store.state.handCards.count
    }

    private func playersCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCellIdentifier", for: indexPath) as! PlayerCell
        let item = store.state.players[indexPath.row]
        cell.update(with: item)
        return cell
    }

    private func handCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HandCellIdentifier", for: indexPath) as! HandCell
        let item = store.state.handCards[indexPath.row]
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
        let item = store.state.handCards[indexPath.row]
        guard item.active,
              let player = store.state.controlledPlayer else {
            return
        }

        Task {
            await store.dispatch(GameAction.play(item.card, player: player))
        }
    }
}

extension GamePlayViewController: PlayerCollectionViewLayoutDelegate {
    func numberOfItemsForGameCollectionViewLayout(layout: PlayerCollectionViewLayout) -> Int {
        store.state.players.count
    }
}

private extension GameView.State {
    var topDiscardImage: UIImage? {
        guard let topDiscard else {
            return nil
        }

        return UIImage(named: Card.extractName(from: topDiscard), in: Bundle.module, with: .none)
    }
}

extension GamePlayViewController: AnimationRendererConfiguration {
    func supportingViewController() -> UIViewController {
        self
    }

    func cardPosition(for location: EventAnimation.Location) -> CGPoint {
        switch location {
        case .deck:
            return deckImageView.superview!.convert(deckImageView.center, to: view)

        case .discard:
            return discardImageView.superview!.convert(discardImageView.center, to: view)

        case .arena:
            return deckImageView.superview!.convert(deckImageView.center, to: view)

        case .hand(let playerId):
            let state = previousState!
            guard let index = state.startOrder.firstIndex(of: playerId) else {
                fatalError("missing player \(playerId)")
            }

            guard let attribute = playersCollectionView.collectionViewLayout
                .layoutAttributesForItem(at: IndexPath(row: index, section: 0)) else {
                fatalError("missing attribute for item at \(index)")
            }

            return playersCollectionView.convert(attribute.center, to: view)

        case .inPlay(let playerId):
            let state = previousState!
            guard let index = state.startOrder.firstIndex(of: playerId) else {
                fatalError("missing player \(playerId)")
            }

            guard let attribute = playersCollectionView.collectionViewLayout
                .layoutAttributesForItem(at: IndexPath(row: index, section: 0)) else {
                fatalError("missing attribute for item at \(index)")
            }

            let cellCenter = playersCollectionView.convert(attribute.center, to: view)
            return cellCenter.applying(CGAffineTransform(translationX: attribute.bounds.size.height / 2, y: 0))
        }
    }

    func cardSize() -> CGSize {
        let width: CGFloat = discardImageView.bounds.size.width
        let height: CGFloat = width / Constant.cardRatio
        return CGSize(width: width, height: height)
    }

    func hiddenCardImage() -> UIImage {
        UIImage(named: Constant.cardBackImageName, in: Bundle.module, with: .none)!
    }

    func cardImage(for cardId: String) -> UIImage {
        UIImage(named: Card.extractName(from: cardId), in: Bundle.module, with: .none)!
    }
}
