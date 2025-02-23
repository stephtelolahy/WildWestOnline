//
//  GameView.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/03/2024.
//

import SwiftUI
import Theme
import Redux
import AppCore
import GameCore

public struct GameView: View {
    public struct State: Equatable {
        let players: [PlayerItem]
        let message: String
        let chooseOne: ChooseOne?
        let handCards: [HandCard]
        let topDiscard: String?
        let topDeck: String?
        let animationDelay: TimeInterval
        let startOrder: [String]
        let deckCount: Int
        let controlledPlayer: String?
        let startPlayer: String

        struct PlayerItem: Equatable {
            let id: String
            let imageName: String
            let displayName: String
            let health: Int
            let maxHealth: Int
            let handCount: Int
            let inPlay: [String]
            let isTurn: Bool
            let isTargeted: Bool
            let isEliminated: Bool
            let role: String?
            let userPhotoUrl: String?
        }

        struct HandCard: Equatable {
            let card: String
            let active: Bool
        }

        struct ChooseOne: Equatable {
            let choiceType: String
            let options: [String]
        }
    }

    @Environment(\.theme) private var theme
    @StateObject private var store: Store<State, Void>

    public init(store: @escaping () -> Store<State, Void>) {
        // SwiftUI ensures that the following initialization uses the
        // closure only once during the lifetime of the view.
        _store = StateObject(wrappedValue: store())
    }

    public var body: some View {
        ZStack {
            theme.backgroundView.edgesIgnoringSafeArea(.all)
            UIViewControllerRepresentableBuilder {
                GamePlayViewController(store: store)
            }
        }
        .foregroundColor(.primary)
        .navigationBarHidden(true)
    }
}

#Preview {
    GameView {
        .init(initialState: .mock, dependencies: ())
    }
}

private extension GameView.State {
    static var mock: Self {
        let player1 = GameView.State.PlayerItem(
            id: "p1",
            imageName: "willyTheKid",
            displayName: "willyTheKid",
            health: 2,
            maxHealth: 4,
            handCount: 5,
            inPlay: ["scope", "jail"],
            isTurn: true,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        let player2 = GameView.State.PlayerItem(
            id: "p2",
            imageName: "calamityJanet",
            displayName: "calamityJanet",
            health: 1,
            maxHealth: 4,
            handCount: 0,
            inPlay: ["scope", "jail"],
            isTurn: false,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )

        return .init(
            players: [player1, player2, player2, player2, player2, player2, player2],
            message: "P1's turn",
            chooseOne: nil,
            handCards: [
                .init(card: "mustang-2♥️", active: false),
                .init(card: "gatling-4♣️", active: true),
                .init(card: "endTurn", active: true)
            ],
            topDiscard: "bang-A♦️",
            topDeck: nil,
            animationDelay: 1,
            startOrder: [],
            deckCount: 12,
            controlledPlayer: "p1",
            startPlayer: "p1"
        )
    }
}

public extension GameView.State {
    init?(appState: AppState) {
        guard let game = appState.game else {
            return nil
        }

        players = game.playerItems
        message = game.message
        chooseOne = game.chooseOne
        handCards = game.handCards
        topDiscard = game.discard.first
        topDeck = game.deck.first
        animationDelay = Double(game.actionDelayMilliSeconds) / 1000.0
        startOrder = game.startOrder
        deckCount = game.deck.count
        controlledPlayer = game.controlledPlayerId
        startPlayer = game.startPlayerId
    }
}

private extension GameState {
    var playerItems: [GameView.State.PlayerItem] {
        self.startOrder.map { playerId in
            let playerObj = players.get(playerId)
            let health = max(0, playerObj.health)
            let maxHealth = playerObj.maxHealth
            let handCount = playerObj.hand.count
            let equipment = playerObj.inPlay
            let isTurn = playerId == turn
            let isEliminated = !playOrder.contains(playerId)
            let isTargeted = queue.contains { $0.payload.target == playerId }

            return .init(
                id: playerId,
                imageName: playerObj.figure,
                displayName: playerObj.figure.uppercased(),
                health: health,
                maxHealth: maxHealth,
                handCount: handCount,
                inPlay: equipment,
                isTurn: isTurn,
                isTargeted: isTargeted,
                isEliminated: isEliminated,
                role: nil,
                userPhotoUrl: nil
            )
        }
    }

    var message: String {
        if let turn = turn {
            "\(turn.uppercased())'s turn"
        } else {
            "-"
        }
    }

    var chooseOne: GameView.State.ChooseOne? {
        guard let controlledPlayer = controlledPlayerId,
              let chooseOne = pendingChoice,
              chooseOne.chooser == controlledPlayer else {
            return  nil
        }

        return .init(
            choiceType: "Unknown",
            options: chooseOne.options.map(\.label)
        )
    }

    var handCards: [GameView.State.HandCard] {
        guard let playerId = players.first(where: { playMode[$0.key] == .manual })?.key,
              let playerObj = players[playerId] else {
            return []
        }

        let activeCards = active[playerId] ?? []

        let hand = players.get(playerId).hand.map { card in
            GameView.State.HandCard(
                card: card,
                active: activeCards.contains(card)
            )
        }

        let abilities = playerObj.abilities.compactMap { card in
            if activeCards.contains(card) {
                GameView.State.HandCard(
                    card: card,
                    active: true
                )
            } else {
                nil
            }
        }

        return hand + abilities
    }

    var startingPlayerId: String {
        playOrder.first!
    }

    var controlledPlayerId: String? {
        playMode.keys.first { playMode[$0] == .manual }
    }

    var startPlayerId: String {
        guard let playerId = startOrder.first else {
            fatalError("unsupported")
        }

        return playerId
    }
}

