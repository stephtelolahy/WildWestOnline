//
//  GameReducerLoop.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Redux

extension GameFeature {
    static func reduceLoop(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) -> Effect {
        let state = state
        return .run {
            await nextAction(state: state, action: action)
        }
    }
}

private func nextAction(state: GameFeature.State, action: ActionProtocol) async -> ActionProtocol? {
    guard let action = action as? Card.Effect else {
        return nil
    }

    // wait some delay if dispatched action was animatable
    if action.isAnimatable {
        try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
    }

    if state.isOver {
        return nil
    }

    if state.pendingChoice != nil {
        return nil
    }

    if state.active.isNotEmpty {
        return nil
    }

    if let triggered = state.triggeredEffect(on: action) {
        return triggered
    }

    if let queued = state.queue.first {
        return queued
    }

    if let activate = state.activatePlayableCards() {
        return activate
    }

    return nil
}

private extension GameFeature.State {
    func triggeredEffect(on event: Card.Effect) -> Card.Effect? {
        guard event.selectors.isEmpty else {
            return nil
        }

        var effects: [Card.Effect] = triggerableElements(on: event).flatMap {
            effectsTriggered(
                by: $0.card,
                ownedBy: $0.player,
                for: event
            )
        }

        // <TODO: remove old effect>
        for player in playOrder
            where event.targetedPlayer == player {
            let triggerableCards = players.get(player).inPlay + players.get(player).abilities
            effects += triggerableCards.flatMap { card in
                oldEffectsTriggered(
                    by: card,
                    ownedBy: player,
                    for: event,
                    behaviorKey: event.name
                )
            }
        }
        // </TODO: remove old effect>

        switch effects.count {
        case 0: return nil
        case 1: return effects.first
        default: return .init(name: .queue, nestedEffects: effects)
        }
    }

    func triggerableElements(on event: Card.Effect) -> [TriggerableElement] {
        var result: [TriggerableElement] = []

        for player in playOrder {
            let triggerableCards = players.get(player).inPlay + players.get(player).abilities
            result += triggerableCards.map { .init(card: $0, player: player) }
        }

        switch event.name {
        case .eliminate:
            let player = event.targetedPlayer!
            let triggerableCards = players.get(player).abilities
            result += triggerableCards.map { .init(card: $0, player: player) }

        case .discardInPlay, .stealInPlay:
            let player = event.targetedPlayer!
            let card = event.targetedCard!
            result += [.init(card: card, player: player)]

        default:
            break
        }

        return result
    }

    func effectsTriggered(
        by card: String,
        ownedBy player: String,
        for event: Card.Effect
    ) -> [Card.Effect] {
        var result: [Card.Effect] = []
        let cardName = Card.extractName(from: card)
        let cardObj = cards.get(cardName)
        for (trigger, effects) in cardObj.behaviour
        where trigger.match(event, card: card, player: player, state: self) {
            result.append(
                contentsOf: effects.map {
                    $0.copy(
                        withPlayer: player,
                        playedCard: card,
                        triggeredBy: [event],
                        targetedPlayer: NonStandardLogic.targetedPlayerForChildEffect($0.name, parentAction: event)
                    )
                }
            )
        }
        return result
    }

    func oldEffectsTriggered(
        by card: String,
        ownedBy player: String,
        for event: Card.Effect,
        behaviorKey: Card.Effect.Name
    ) -> [Card.Effect] {
        let cardName = Card.extractName(from: card)
        let behavior = cards.get(cardName).behaviourOld[behaviorKey] ?? []
        let context = Card.Effect(name: event.name, sourcePlayer: player)
        return behavior.map {
            $0.copy(
                withPlayer: player,
                playedCard: card,
                triggeredBy: [event],
                targetedPlayer: NonStandardLogic.targetedPlayerForChildEffect($0.name, parentAction: context)
            )
        }
    }

    func activatePlayableCards() -> Card.Effect? {
        guard let player = turn else {
            return nil
        }

        let playerObj = players.get(player)
        let activeCards = (playerObj.abilities + players.get(player).hand)
            .filter {
                Card.Effect.validatePlay(card: $0, player: player, state: self)
            }

        guard activeCards.isNotEmpty else {
            return nil
        }

        return Card.Effect.activate(activeCards, player: player)
    }
}

private extension Card.Effect {
    static func validatePlay(card: String, player: String, state: GameFeature.State) -> Bool {
        let action = Card.Effect.preparePlay(card, player: player)
        do {
            try action.validate(state: state)
            // print("🟢 validatePlay: \(card)")
            return true
        } catch {
            // print("🛑 validatePlay: \(card)\tthrows: \(error)")
            return false
        }
    }

    func validate(state: GameFeature.State) throws {
        var newState = state

        _ = GameFeature.reduceMechanics(into: &newState, action: self, dependencies: ())
        if let error = newState.lastActionError {
            throw error
        }

        if let choice = newState.pendingChoice {
            for option in choice.options {
                let next = Card.Effect.choose(option.label, player: choice.chooser)
                try next.validate(state: newState)
            }
        } else if newState.queue.isNotEmpty {
            let next = newState.queue.removeFirst()
            try next.validate(state: newState)
        }
    }
}

private extension Card.Effect {
    var isAnimatable: Bool {
        guard selectors.isEmpty else {
            return false
        }

        switch name {
        case .play,
                .equip,
                .handicap,
                .drawDeck,
                .drawDiscard,
                .drawDiscovered,
                .draw,
                .stealHand,
                .stealInPlay,
                .passInPlay,
                .discardHand,
                .discardInPlay,
                .discover:
            return true

        default:
            return false
        }
    }
}

private struct TriggerableElement {
    let card: String
    let player: String
}
