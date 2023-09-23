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

    if let effects = evaluateTriggeredEffects(action: action, state: state) {
        return Just(GameAction.group(effects)).eraseToAnyPublisher()
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

func evaluateTriggeredEffects(action: GameAction, state: GameState) -> [GameAction]? {
    let players = playersThatCouldTriggerEffects(action: action, state: state)
    var triggered: [GameAction] = []
    for player in players {
        let cards = cardsThatCouldTriggerEffects(action: action, player: player, state: state)
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

    return triggered
}

private func playersThatCouldTriggerEffects(action: GameAction, state: GameState) -> [String] {
    var players = state.playOrder
    if case let .eliminate(eliminatedPlayer) = action {
        players.insert(eliminatedPlayer, at: 0)
    }
    return players
}

private func cardsThatCouldTriggerEffects(action: GameAction, player: String, state: GameState) -> [String] {
    let playerObj = state.player(player)
    var cards = playerObj.inPlay.cards + playerObj.abilities
    if case let .discardInPlay(discardedCard, discardingPlayer) = action,
       discardingPlayer == player {
        cards.insert(discardedCard, at: 0)
    }
    if case let .stealInPlay(stolenCard, stolenPlayer, _) = action,
       stolenPlayer == player {
        cards.insert(stolenCard, at: 0)
    }
    if case let .playImmediate(playedCard, _, playingPlayer) = action,
       playingPlayer == player {
        cards.insert(playedCard, at: 0)
    }
    return cards
}

private func triggeredEffect(by card: String, player: String, state: GameState) -> GameAction? {
    let cardName = card.extractName()
    guard let cardObj = state.cardRef[cardName] else {
        return nil
    }

    var ctx: EffectContext = [.actor: player, .card: card]

    for rule in cardObj.rules {
        do {
            // Validate playRequirements
            if let onPlayReq = rule.playReqs.first(where: { PlayReq.onPlays.contains($0) }) {
                // onPlayRule's other requirements are already matched before dispatching action
                try onPlayReq.match(state: state, ctx: ctx)
            } else {
                for playReq in rule.playReqs {
                    try playReq.match(state: state, ctx: ctx)
                }
            }

            // extract child effect if targeting selectable player
            var sideEffect = rule.effect
            if case let .target(requiredTarget, childEffect) = sideEffect {
                let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
                if case .selectable = resolvedTarget {
                    sideEffect = childEffect

                    // add target to context
                    if case let .playHandicap(card, target, player) = state.event,
                       card == ctx.get(.card),
                       player == ctx.get(.actor) {
                        ctx[.target] = target
                    }

                    if case let .playImmediate(card, target, player) = state.event,
                       card == ctx.get(.card),
                       player == ctx.get(.actor) {
                        ctx[.target] = target
                    }

                    precondition(ctx[.target] != nil)
                }
            }

            return .resolve(sideEffect, ctx: ctx)
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
