//
//  GameReducerLoop.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Redux
import CardDefinition

extension GameFeature {
    static func reducerLoop(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        let state = state
        return .run {
            await nextAction(state: state, action: action, dependencies: dependencies)
        }
    }

    private static func nextAction(state: State, action: Action, dependencies: Dependencies) async -> Action? {
        if action.isAnimatable {
            try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
        }

        if state.isOver {
            return nil
        }

        if state.pendingChoice != nil {
            return nil
        }

        if state.playable != nil {
            return nil
        }

        if let triggered = state.triggeredEffect(on: action) {
            return triggered
        }

        if let queued = state.queue.first {
            return queued
        }

        if state.showPlayableCards,
           let activate = state.activatePlayableCards(dependencies: dependencies) {
            return activate
        }

        return nil
    }
}

private extension GameFeature.State {
    func triggeredEffect(on action: GameFeature.Action) -> GameFeature.Action? {
        guard action.selectors.isEmpty else {
            return nil
        }

        let effects: [GameFeature.Action] = triggerableElements(on: action).flatMap {
            effectsTriggered(
                by: $0.card,
                ownedBy: $0.player,
                for: action
            )
        }

        switch effects.count {
        case 0: return nil
        case 1: return effects.first
        default: return .init(name: .queue, children: effects)
        }
    }

    struct TriggerableElement {
        let card: String
        let player: String
    }

    func triggerableElements(on action: GameFeature.Action) -> [TriggerableElement] {
        var result: [TriggerableElement] = []

        for player in playOrder {
            let playerObj = players.get(player)
            let triggerableCards = playerObj.inPlay + playerObj.figure + auras
            result += triggerableCards.map { .init(card: $0, player: player) }
        }

        switch action.name {
        case .eliminate:
            guard let player = action.targetedPlayer else { fatalError("Missing targetedPlayer") }

            result += auras.map { .init(card: $0, player: player) }

        case .discardInPlay, .stealInPlay:
            guard let player = action.targetedPlayer else { fatalError("Missing targetedPlayer") }
            guard let card = action.targetedCard else { fatalError("Missing targetedCard") }

            result += [.init(card: card, player: player)]

        default:
            break
        }

        return result
    }

    func effectsTriggered(
        by card: String,
        ownedBy player: String,
        for event: GameFeature.Action
    ) -> [GameFeature.Action] {
        let cardName = Card.name(of: card)
        let cardObj = cards.get(cardName)
        return cardObj.effects
            .filter { $0.trigger.match(event, card: card, player: player, state: self) }
            .map {
                $0.toInstance(
                    withPlayer: player,
                    playedCard: card,
                    triggeredBy: [event],
                    targetedPlayer: NonStandardLogic.targetedPlayerForTriggeredEffect($0.action, parentAction: event)
                )
            }
    }

    func activatePlayableCards(dependencies: Dependencies) -> GameFeature.Action? {
        guard let player = turn else {
            return nil
        }

        let playerObj = players.get(player)
        let playableCards = (players.get(player).hand + playerObj.figure + auras)
            .filter {
                Self.isCardPlayable($0, player: player, state: self, dependencies: dependencies)
            }

        guard playableCards.isNotEmpty else {
            return nil
        }

        return .activate(playableCards, player: player)
    }

    static func isCardPlayable(
        _ card: String,
        player: String,
        state: GameFeature.State,
        dependencies: Dependencies
    ) -> Bool {
        let action = GameFeature.Action.preparePlay(card, player: player)
        do {
            try resolveUntilCompleted(action, state: state, dependencies: dependencies)
            // print("🟢 isCardPlayable: \(card)")
            return true
        } catch {
            // print("🛑 isCardPlayable: \(card)\tthrows: \(error)")
            return false
        }
    }

    static func resolveUntilCompleted(_ action: GameFeature.Action, state: GameFeature.State, dependencies: Dependencies) throws {
        var newState = state

        _ = GameFeature.reducerMechanics(into: &newState, action: action, dependencies: dependencies)
        if let error = newState.lastError {
            throw error
        }

        // <add preparePlay effects>
        if case .preparePlay = action.name {
            let triggered = newState.triggerableElements(on: action).flatMap {
                state.effectsTriggered(by: $0.card, ownedBy: $0.player, for: action)
            }
            newState.queue.insert(contentsOf: triggered, at: 0)
        }
        // </add preparePlay effects>

        if let choice = newState.pendingChoice {
            for option in choice.options {
                let next = GameFeature.Action.choose(option.label, player: choice.chooser)
                try resolveUntilCompleted(next, state: newState, dependencies: dependencies)
            }
        } else if newState.queue.isNotEmpty {
            let next = newState.queue.removeFirst()
            try resolveUntilCompleted(next, state: newState, dependencies: dependencies)
        }
    }
}

private extension GameFeature.Action {
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
