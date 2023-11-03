//  GameLoopMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//
import Redux
import Combine

public let gameLoopMiddleware: Middleware<GameState> = { state, action in
    guard let action = action as? GameAction else {
        return Empty().eraseToAnyPublisher()
    }

    let middleWares: [GameActionMiddleware] = [
        GameOverMiddleware(),
        TriggeredEffectsMiddleware(),
        NextActionMiddleware(),
        ActivateCardsMiddleware()
    ]

    for middleware in middleWares {
        if let output = middleware.handle(action: action, state: state) {
            return Just(output).eraseToAnyPublisher()
        }
    }

    return Empty().eraseToAnyPublisher()
}

protocol GameActionMiddleware {
    func handle(action: GameAction, state: GameState) -> GameAction?
}

struct NextActionMiddleware: GameActionMiddleware {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        switch action {
        case .setGameOver,
                .chooseOne,
                .activateCards:
            nil

        default:
            state.queue.first
        }
    }
}

struct TriggeredEffectsMiddleware: GameActionMiddleware {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        var triggered: [GameAction] = []

        // active players
        for player in state.playOrder {
            let playerObj = state.player(player)
            let cards = triggerableCardsOfActivePlayer(playerObj, state: state)
            for card in cards {
                if let action = triggeredEffect(by: card, player: player, state: state) {
                    triggered.append(action)
                }
            }
        }

        // just eliminated player
        if case let .eliminate(player) = action {
            let playerObj = state.player(player)
            let cards = triggerableCardsOfEliminatedPlayer(playerObj)
            for card in cards {
                if let action = triggeredEffect(by: card, player: player, state: state) {
                    triggered.append(action)
                }
            }
        }

        // Ignore empty
        guard triggered.isNotEmpty else {
            return nil
        }

        return .group(triggered)
    }

    private func triggeredEffect(by card: String, player: String, state: GameState) -> GameAction? {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            return nil
        }

        let playReqContext = PlayReqContext(actor: player)
        for (playReq, effect) in cardObj.rules where  playReq.match(state: state, ctx: playReqContext) {
            let linkedAction = linkedActionForTriggeredEffect(state: state)
            let ctx = EffectContext(actor: player, card: card, linkedAction: linkedAction)
            return GameAction.effect(effect, ctx: ctx)
        }

        return nil
    }

    private func triggerableCardsOfActivePlayer(_ playerObj: Player, state: GameState) -> [String] {
        playerObj.inPlay.cards
        + playerObj.abilities
        + playerObj.hand.cards.filter { state.isCardCancellingEffect($0) }
    }

    private func triggerableCardsOfEliminatedPlayer(_ playerObj: Player) -> [String] {
        playerObj.abilities
    }

    private func linkedActionForTriggeredEffect(state: GameState) -> GameAction? {
        if let event = state.event,
           case let .effect(cardEffect, _) = event,
           case .shoot = cardEffect,
           let nextAction = state.queue.first,
           case .damage = nextAction {
            return nextAction
        }

        return nil
    }
}

private extension GameState {
    func isCardCancellingEffect(_ card: String) -> Bool {
        let cardName = card.extractName()
        guard let cardObj = cardRef[cardName] else {
            return false
        }

        return cardObj.rules.contains(where: {
            if $0.key == .onPlayImmediate, 
                case .cancel = $0.value {
                return true
            } else {
                return false
            }
        })
    }
}

struct ActivateCardsMiddleware: GameActionMiddleware {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        guard state.queue.isEmpty,
              state.isOver == nil,
              state.chooseOne == nil,
              state.active == nil,
              let player = state.turn else {
            return nil
        }

        var activeCards: [String] = []
        let playerObj = state.player(player)
        for card in activableCardsOfPlayer(playerObj)
        where GameAction.validatePlay(card: card, player: player, state: state) {
            activeCards.append(card)
        }

        // Ignore empty
        guard activeCards.isNotEmpty else {
            return nil
        }

        return .activateCards(player: player, cards: activeCards)
    }

    private func activableCardsOfPlayer(_ playerObj: Player) -> [String] {
        playerObj.abilities + playerObj.hand.cards
    }
}

struct GameOverMiddleware: GameActionMiddleware {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        guard case .eliminate = action,
              let winner = evaluateWinner(state: state)else {
            return nil
        }

        return .setGameOver(winner: winner)
    }

    private func evaluateWinner(state: GameState) -> String? {
        if state.playOrder.count == 1 {
            return state.playOrder[0]
        }

        return nil
    }
}
