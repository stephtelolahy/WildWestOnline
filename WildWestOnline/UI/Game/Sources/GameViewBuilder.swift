//
//  GameViewBuilder.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/09/2024.
//

import SwiftUI
import Redux
import AppCore
import GameCore

public struct GameViewBuilder: View {
    @EnvironmentObject private var store: Store<AppState>

    public init() {}

    public var body: some View {
        GameView {
            store.projection(GameView.presenter)
        }
    }
}

extension GameView {
    static let presenter: Presenter<AppState, State> = { state in
        guard let game = state.game else {
            return nil
        }

        return .init(
            players: game.playerItems,
            message: game.message,
            chooseOne: game.viewChooseOne,
            handCards: game.handCards,
            topDiscard: game.discard.first,
            topDeck: game.deck.first,
            animationDelay: game.waitDelaySeconds,
            startOrder: game.startOrder,
            deckCount: game.deck.count,
            controlledPlayer: game.controlledPlayerId,
            startPlayer: game.startPlayerId
        )
    }
}

private extension GameState {
    var playerItems: [GameView.State.PlayerItem] {
        self.startOrder.map { playerId in
            let playerObj = player(playerId)
            let health = max(0, playerObj.health)
            let maxHealth = playerObj.maxHealth
            let handCount = playerObj.hand.count
            let equipment = playerObj.inPlay
            let isTurn = playerId == turn
            let isEliminated = !playOrder.contains(playerId)
            let isTargeted = queue.contains { $0.isEffectTargeting(playerId) }

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

    var viewChooseOne: GameView.State.ChooseOne? {
        guard let controlledPlayer = controlledPlayerId,
              let chooseOne = chooseOne[controlledPlayer] else {
            return  nil
        }

        return .init(
            choiceType: chooseOne.type.rawValue,
            options: chooseOne.options
        )
    }

    var handCards: [GameView.State.HandCard] {
        guard let playerId = players.first(where: { playMode[$0.key] == .manual })?.key,
              let playerObj = players[playerId] else {
            return []
        }

        let activeCards = active[playerId] ?? []

        let hand = playerObj.hand.map { card in
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
        playMode.keys.first(where: { playMode[$0] == .manual })
    }

    var startPlayerId: String {
        guard let playerId = startOrder.first else {
            fatalError("unsupported")
        }

        return playerId
    }
}
