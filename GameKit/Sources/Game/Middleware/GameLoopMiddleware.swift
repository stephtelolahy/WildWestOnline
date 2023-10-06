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

    if let gameOver = evaluateGameOver(action: action, state: state) {
        return Just(gameOver).eraseToAnyPublisher()
    } else if let effects = evaluateTriggeredEffects(action: action, state: state) {
        return Just(effects).eraseToAnyPublisher()
    } else if let nextAction = evaluateNextAction(action: action, state: state) {
        return Just(nextAction).eraseToAnyPublisher()
    } else if let activateCards = evaluateActiveCards(state: state) {
        return Just(activateCards).eraseToAnyPublisher()
    } else {
        return Empty().eraseToAnyPublisher()
    }
}

private func evaluateNextAction(action: GameAction, state: GameState) -> GameAction? {
    switch action {
    case .setGameOver,
            .chooseOne,
            .activateCards:
        nil

    default:
        state.queue.first
    }
}

private func evaluateTriggeredEffects(action: GameAction, state: GameState) -> GameAction? {
    var triggered: [GameAction] = []

    var players = state.playOrder
    if case let .eliminate(eliminatedPlayer) = action {
        players.insert(eliminatedPlayer, at: 0)
    }

    for player in players {

        let playerObj = state.player(player)
        let cards = playerObj.inPlay.cards + playerObj.abilities

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

    let playReqContext = PlayReqContext(actor: player, card: card)

    for rule in cardObj.rules {
        do {
            // Validate playRequirements
            for playReq in rule.playReqs {
                try playReq.match(state: state, ctx: playReqContext)
            }

            let ctx = EffectContext(actor: player, card: card)
            return GameAction.effect(rule.effect, ctx: ctx)
        } catch {
            continue
        }
    }

    return nil
}

private func evaluateActiveCards(state: GameState) -> GameAction? {
    guard state.queue.isEmpty,
          state.isOver == nil,
          state.chooseOne == nil,
          state.active == nil,
          let player = state.turn else {
        return nil
    }

    var activeCards: [String] = []
    let playerObj = state.player(player)
    for card in (playerObj.hand.cards + playerObj.abilities)
    where GameAction.validatePlay(card: card, player: player, state: state) {
        activeCards.append(card)
    }

    if activeCards.isNotEmpty {
        return GameAction.activateCards(player: player, cards: activeCards)
    }
    return nil
}

private func evaluateGameOver(action: GameAction, state: GameState) -> GameAction? {
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
