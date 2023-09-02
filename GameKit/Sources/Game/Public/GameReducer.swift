//
//  GameReducer.swift
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
            state = queueTriggered(action: action, state: state)
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
        guard case let .play(card, actor) = action,
              active.player == actor,
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

private func queueTriggered(action: GameAction, state: GameState) -> GameState {
    var state = state
    var players = state.playOrder
    if case let .eliminate(justEliminated) = state.event {
        players.append(justEliminated)
    }

    var triggered: [GameAction] = []
    for actor in players {
        let actorObj = state.player(actor)
        var cards = actorObj.inPlay.cards + actorObj.abilities + state.abilities
        if case let .discard(justDiscarded, _) = state.event {
            cards.append(justDiscarded)
        }

        for card in cards {
            if let triggeredAction = triggeredAction(by: card, actor: actor, state: state) {
                triggered.append(triggeredAction)
            }
        }
    }
    state.queue.insert(contentsOf: triggered, at: 0)
    return state
}

private func triggeredAction(by card: String, actor: String, state: GameState) -> GameAction? {
    let cardName = card.extractName()
    guard let cardObj = state.cardRef[cardName] else {
        return nil
    }

    for (eventReq, effect) in cardObj.actions {
        do {
            let ctx: EffectContext = [.actor: actor, .card: card]
            let eventMatched = try eventReq.match(state: state, ctx: ctx)
            if eventMatched {
                let gameAction = GameAction.resolve(effect, ctx: ctx)
                try gameAction.validate(state: state)

                return gameAction
            }
        } catch {
            return nil
        }
    }
    return nil
}
