//
//  GameViewState.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/10/2025.
//
// swiftlint:disable force_unwrapping

import Foundation
import SwiftUI
import Redux
import AppFeature
import GameFeature

public extension GameView {
    struct ViewState: Equatable {
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
        let actionDelaySeconds: Double
        let lastEvent: GameFeature.Action?

        struct PlayerItem: Equatable {
            let id: String
            let imageName: String
            let displayName: String
            let health: Int
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
            let resolvingAction: Card.ActionName
            let chooser: String
            let options: [String]
        }
    }

    typealias ViewStore = Store<ViewState, AppFeature.Action, Void>
}

public extension GameView.ViewState {
    init?(appState: AppFeature.State) {
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
        actionDelaySeconds = Double(appState.settings.actionDelayMilliSeconds) / 1000.0
        lastEvent = game.lastEvent
    }
}

private extension GameFeature.State {
    var playerItems: [GameView.ViewState.PlayerItem] {
        self.startOrder.map { playerId in
            let playerObj = players.get(playerId)
            let health = max(0, playerObj.health)
            let handCount = playerObj.hand.count
            let equipment = playerObj.inPlay
            let isTurn = playerId == turn
            let isEliminated = !playOrder.contains(playerId)
            let isTargeted = isTargeted(playerId)

            return .init(
                id: playerId,
                imageName: playerObj.figure,
                displayName: playerObj.figure.uppercased(),
                health: health,
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
        if let turn {
            "\(turn.uppercased())'s turn"
        } else {
            "-"
        }
    }

    var chooseOne: GameView.ViewState.ChooseOne? {
        guard let controlledPlayer = controlledPlayerId,
              let choice = pendingChoice(for: controlledPlayer) else {
            return  nil
        }

        return .init(
            resolvingAction: choice.action,
            chooser: choice.prompt.chooser,
            options: choice.prompt.options.map(\.label)
        )
    }

    var handCards: [GameView.ViewState.HandCard] {
        guard let controlledPlayer = controlledPlayerId else {
            return []
        }

        let activeCards = active[controlledPlayer] ?? []
        let handCards = players.get(controlledPlayer).hand

        let hand = handCards.map { card in
            GameView.ViewState.HandCard(
                card: card,
                active: activeCards.contains(card)
            )
        }

        let abilities = activeCards.compactMap { card in
            if !handCards.contains(card) {
                GameView.ViewState.HandCard(
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
            fatalError("Missing start player")
        }

        return playerId
    }
}
