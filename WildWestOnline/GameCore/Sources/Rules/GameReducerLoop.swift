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
        // process only resolved event
        guard event.selectors.isEmpty else {
            return nil
        }

        var triggered: [Card.Effect] = []

        for player in playOrder {
            let playerObj = players.get(player)
            let triggerableCards = playerObj.inPlay + playerObj.abilities
            for card in triggerableCards {
                if let effects = triggeredEffects(on: event, by: card, player: player) {
                    triggered.append(contentsOf: effects)
                }
            }
        }

        if event.name == .eliminate {
            let player = event.payload.targetedPlayer!
            let playerObj = players.get(player)
            for card in playerObj.abilities {
                if let effects = triggeredEffects(on: event, by: card, player: player) {
                    triggered.append(contentsOf: effects)
                }
            }
        }

        if event.name == .equip {
            let player = event.payload.player
            let card = event.payload.playedCard
            if let effects = activeEffects(on: event, by: card, player: player) {
                triggered.append(contentsOf: effects)
            }
        }

        if event.name == .discardInPlay || event.name == .stealInPlay {
            let player = event.payload.targetedPlayer!
            guard let card = event.payload.card else {
                fatalError("Missing payload.card")
            }

            if let effects = inactiveEffects(on: event, by: card, player: player) {
                triggered.append(contentsOf: effects)
            }
        }

        if triggered.isEmpty {
            return nil
        } else if triggered.count == 1 {
            return triggered[0]
        } else {
            return .init(
                name: .queue,
                payload: .init(
                    children: triggered
                )
            )
        }
    }

    func triggeredEffects(on event: Card.Effect, by card: String, player: String) -> [Card.Effect]? {
        let cardName = Card.extractName(from: card)
        let cardObj = cards.get(cardName)
        guard cardObj.canTrigger.isNotEmpty,
              cardObj.canTrigger.contains(where: { $0.match(event: event, player: player, state: self) }) else {
            return nil
        }

        return cardObj.onTrigger.map {
            $0.copy(
                withPlayer: player,
                played: card,
                target: NonStandardLogic.childEffectTarget($0.name, payload: .init(player: player)),
                triggeredByName: event.name,
                triggeredByPayload: event.payload
            )
        }
    }

    func activeEffects(on event: Card.Effect, by card: String, player: String) -> [Card.Effect]? {
        let cardName = Card.extractName(from: card)
        let cardObj = cards.get(cardName)
        return cardObj.onActive.map {
            $0.copy(
                withPlayer: player,
                played: card,
                target: NonStandardLogic.childEffectTarget($0.name, payload: .init(player: player)),
                triggeredByName: event.name,
                triggeredByPayload: event.payload
            )
        }
    }

    func inactiveEffects(on event: Card.Effect, by card: String, player: String) -> [Card.Effect]? {
        let cardName = Card.extractName(from: card)
        let cardObj = cards.get(cardName)
        return cardObj.onInactive.map {
            $0.copy(
                withPlayer: player,
                played: card,
                target: NonStandardLogic.childEffectTarget($0.name, payload: .init(player: player)),
                triggeredByName: event.name,
                triggeredByPayload: event.payload
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
//            print("🟢 validatePlay: \(card)")
            return true
        } catch {
//            print("🛑 validatePlay: \(card)\tthrows: \(error)")
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
