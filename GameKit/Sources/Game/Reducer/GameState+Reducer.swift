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
    var state = state
    var players = state.playOrder
    if case let .eliminate(justEliminated) = state.event {
        players.append(justEliminated)
    }

    var triggered: [GameAction] = []
    for player in players {
        let playerObj = state.player(player)
        var cards = playerObj.inPlay.cards + playerObj.abilities + state.abilities
        if case let .discardInPlay(justDiscardedInPlay, _) = state.event {
            cards.append(justDiscardedInPlay)
        }
        if case let .stealInPlay(justDiscardedInPlay, _, _) = state.event {
            cards.append(justDiscardedInPlay)
        }
        for card in cards {
            if let triggeredAction = triggeredAction(by: card, player: player, state: state) {
                triggered.append(triggeredAction)
            }
        }
    }
    state.queue.insert(contentsOf: triggered, at: 0)
    return state
}

private func triggeredAction(by card: String, player: String, state: GameState) -> GameAction? {
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
            let action = GameAction.resolve(rule.effect, ctx: ctx)
            try action.validate(state: state)
            return action
        } catch {
            continue
        }
    }

    return nil
}
