// swiftlint:disable:this file_name
//
//  GamePlayViewModel.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/03/2024.
//
// swiftlint:disable nesting

import AppCore
import Foundation
import GameCore
import Redux

public extension GamePlayView {
    struct State: Equatable {
        public let players: [PlayerItem]
        public let message: String
        public let chooseOneData: ChooseOneData?
        public let handActions: [CardAction]
        public let topDiscard: String?
        public let topDeck: String?
        public let animationDelay: TimeInterval
        public let startOrder: [String]
        public let deckCount: Int
        public let occurredEvent: GameAction?
        
        public struct PlayerItem: Equatable {
            public let id: String
            public let imageName: String
            public let displayName: String
            public let health: Int
            public let maxHealth: Int
            public let handCount: Int
            public let inPlay: [String]
            public let isTurn: Bool
            public let isTargeted: Bool
            public let isEliminated: Bool
            public let role: String?
            public let userPhotoUrl: String?
        }
        
        public struct CardAction: Equatable {
            public let card: String
            public let active: Bool
        }
        
        public struct ChooseOneData: Equatable {
            public let choiceType: ChoiceType
            public let options: [String]
        }
    }
    
    enum Action {
        case didStartTurn(player: String)
        case didTapQuitButton
        case didPlay(String, player: String)
        case didChoose(String, player: String)
    }
    
    struct Connector: Redux.Connector {
        public init() {}
        
        public func deriveState(_ state: AppState) -> State? {
            guard let game = state.game else {
                return nil
            }
            
            return .init(
                players: game.playerItems,
                message: game.message,
                chooseOneData: game.chooseOneData,
                handActions: game.handActions,
                topDiscard: game.discard.first,
                topDeck: game.deck.first,
                animationDelay: Double(game.waitDelayMilliseconds) / 1000.0,
                startOrder: game.startOrder,
                deckCount: game.deck.count,
                occurredEvent: game.event
            )
        }
        
        public func embedAction(_ action: Action, state: AppState) -> AppAction {
            switch action {
            case .didStartTurn(let player):
                    .game(.startTurn(player: player))
                
            case .didTapQuitButton:
                    .quitGame
                
            case let .didPlay(card, player):
                    .game(.play(card, player: player))
                
            case let .didChoose(option, player):
                    .game(.choose(option, player: player))
            }
        }
    }
}

private extension GameState {
    var playerItems: [GamePlayView.State.PlayerItem] {
        self.startOrder.map { playerId in
            let playerObj = player(playerId)
            let health = max(0, playerObj.health)
            let maxHealth = playerObj.attributes[.maxHealth] ?? 0
            let handCount = playerObj.hand.count
            let equipment = playerObj.inPlay
            let isTurn = playerId == turn
            let isEliminated = !playOrder.contains(playerId)
            let isTargeted = sequence.contains { $0.isEffectTargeting(playerId) }
            
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
        if let turn {
            "\(turn.uppercased())'s turn"
        } else {
            "-"
        }
    }
    
    var chooseOneData: GamePlayView.State.ChooseOneData? {
        guard let chooseOne = chooseOne.first(where: { playMode[$0.key] == .manual }) else {
            return  nil
        }
        
        return .init(
            choiceType: chooseOne.value.type,
            options: chooseOne.value.options
        )
    }
    
    var handActions: [GamePlayView.State.CardAction] {
        guard let playerId = players.first(where: { playMode[$0.key] == .manual })?.key,
              let playerObj = players[playerId] else {
            return []
        }
        
        let activeCards = self.active[playerId] ?? []
        
        let handCardActions = playerObj.hand.map { card in
            GamePlayView.State.CardAction(card: card, active: activeCards.contains(card))
        }
        
        let abilityActions = playerObj.abilities.compactMap { card in
            if activeCards.contains(card) {
                GamePlayView.State.CardAction(card: card, active: true)
            } else {
                nil
            }
        }
        
        return handCardActions + abilityActions
    }
}
