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

/// Evaluate triggered efofects given current state
private func evaluateTriggeredEffects(action: GameAction, state: GameState) -> [GameAction]? {
    // determine active players
    var players = state.playOrder
    if case let .eliminate(justEliminated) = state.event {
        players.insert(justEliminated, at: 0)
    }

    var triggered: [GameAction] = []
    for player in players {
        let playerObj = state.player(player)

        // determine cards that could trigger effects
        var cards = playerObj.inPlay.cards + playerObj.abilities
        if case let .discardInPlay(justDiscardedFromPlay, aPlayer) = state.event,
           aPlayer == player {
            cards.insert(justDiscardedFromPlay, at: 0)
        }
        if case let .stealInPlay(justDiscardedFromPlay, aTarget, _) = state.event,
           aTarget == player {
            cards.insert(justDiscardedFromPlay, at: 0)
        }
        if case let .playImmediate(justDiscardedFromHand, _, aPlayer) = state.event,
           aPlayer == player {
            cards.insert(justDiscardedFromHand, at: 0)
        }
        for card in cards {
            if let action = triggeredAction(by: card, player: player, state: state) {
                triggered.append(action)
            }
        }
    }

    guard triggered.isNotEmpty else {
        return nil
    }

    return triggered
}

private func triggeredAction(by card: String, player: String, state: GameState) -> GameAction? {
    let cardName = card.extractName()
    guard let cardObj = state.cardRef[cardName] else {
        return nil
    }

    var ctx: EffectContext = [.actor: player, .card: card]

    for rule in cardObj.rules {
        do {
            for playReq in rule.playReqs where shouldMatchPlayReq(playReq) {
                try playReq.match(state: state, ctx: ctx)
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

            let action = GameAction.resolve(sideEffect, ctx: ctx)

            // validate effect
            if shouldValidateEffectsTriggeredBy(state.event) {
                try action.validate(state: state)
            }

            return action
        } catch {
            continue
        }
    }

    return nil
}

/// Verify if we should forward the triggered effect eventual failure into the game queue
/// Because since we trigger card’s main effect separately from resolving Play action,
/// the failure of the effect could not be linked to the card playability
private func shouldValidateEffectsTriggeredBy(_ action: GameAction?) -> Bool {
    switch action {
    case .playImmediate,
            .playAbility,
            .playHandicap,
            .playEquipment:
        false
    default:
        true
    }
}

/// Becase we are marking card played after resolving play action,
/// the condition `isTimesPerTurnLessThan` will fail next time verifying onPlay requirements
private func shouldMatchPlayReq(_ playReq: PlayReq) -> Bool {
    switch playReq {
    case .isMaxTimesPerTurn:
        false
    default:
        true
    }
}
