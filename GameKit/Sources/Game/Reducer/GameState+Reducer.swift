//
//  GameState+Reducer.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//
import Redux

public extension GameState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? GameAction else {
            return state
        }

        guard state.isOver == nil else {
            return state
        }

        var state = state

        state.event = nil
        state.error = nil

        do {
            state = try prepare(action: action, state: state)
            state = try action.reduce(state: state)
            state.event = action
            state = queueTriggered(state: state)
        } catch {
            state.error = error as? GameError
        }

        return state
    }
}

private func prepare(action: GameAction, state: GameState) throws -> GameState {
    var state = state

    if let chooseOne = state.chooseOne {
        guard chooseOne.options.values.contains(action) else {
            throw GameError.unwaitedAction
        }
        state.chooseOne = nil
    } else if let active = state.active {
        guard case let .play(card, player) = action,
              active.player == player,
              active.cards.contains(card) else {
            throw GameError.unwaitedAction
        }
        state.active = nil
    } else if state.queue.first == action {
        state.queue.removeFirst()
    } else if case .play = action {
        _ = try action.validate(state: state)
    }

    return state
}

private func queueTriggered(state: GameState) -> GameState {
    guard let triggered = state.evaluateTriggeredEffects() else {
        return state
    }

    var state = state
    state.queue.insert(contentsOf: triggered, at: 0)
    return state
}

private extension GameState {
    /// Evaluate triggered effects given current state
    func evaluateTriggeredEffects() -> [GameAction]? {
        let state = self
        var players = state.playOrder
        if case let .eliminate(justEliminated) = state.event {
            players.insert(justEliminated, at: 0)
        }

        var triggered: [GameAction] = []
        for player in players {
            let playerObj = state.player(player)
            var cards = playerObj.inPlay.cards + playerObj.abilities
            if case let .discardInPlay(justDiscardedFromPlay, _) = state.event {
                cards.append(justDiscardedFromPlay)
            }
            if case let .stealInPlay(justDiscardedFromPlay, _, _) = state.event {
                cards.append(justDiscardedFromPlay)
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

    func triggeredAction(by card: String, player: String, state: GameState) -> GameAction? {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            return nil
        }

        let ctx: EffectContext = [.actor: player, .card: card]

        for rule in cardObj.rules {
            do {
                for playReq in rule.playReqs {
                    try playReq.match(state: state, ctx: ctx)
                }

                // extract child effect if targeting selectable player
                var sideEffect = rule.effect
                if case let .target(requiredTarget, childEffect) = sideEffect {
                    let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
                    if case .selectable = resolvedTarget {
                        sideEffect = childEffect
                    }
                }
                
                let action = GameAction.resolve(sideEffect, ctx: ctx)
                try action.validate(state: state)
                return action
            } catch {
                continue
            }
        }

        return nil
    }
}
