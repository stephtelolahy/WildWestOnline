//
//  GameMiddleware.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//
// swiftlint:disable discouraged_optional_collection
import Combine
import Foundation

/// Game loop features
public extension Middlewares {
    static var updateGame: Middleware<GameState> {
        { state, action in
            guard let action = action as? GameAction else {
                return nil
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

            if let pending = state.queue.first {
                return pending
            }

            if let activate = state.activatePlayableCards() {
                return activate
            }

            return nil
        }
    }
}

private extension GameState {
    func triggeredEffect(on event: GameAction) -> GameAction? {
        var triggered: [GameAction] = []

        for player in playOrder {
            let playerObj = players.get(player)
            let triggerableCards = playerObj.inPlay + playerObj.abilities
            for card in triggerableCards {
                if let effects = triggeredEffects(on: event, by: card, player: player) {
                    triggered.append(contentsOf: effects)
                }
            }
        }

        if event.kind == .eliminate {
            let player = event.payload.target
            let playerObj = players.get(player)
            for card in playerObj.abilities {
                if let effects = triggeredEffects(on: event, by: card, player: player) {
                    triggered.append(contentsOf: effects)
                }
            }
        }

        guard triggered.isNotEmpty else {
            return nil
        }

        if triggered.count == 1 {
            return triggered[0]
        } else {
            return .init(
                kind: .queue,
                payload: .init(
                    children: triggered
                )
            )
        }
    }

    func triggeredEffects(
        on event: GameAction,
        by card: String,
        player: String
    ) -> [GameAction]? {
        let cardName = Card.extractName(from: card)
        guard let cardObj = cards[cardName] else {
            fatalError("Missing definition of \(cardName)")
        }

        guard cardObj.canTrigger.isNotEmpty else {
            return nil
        }

        for eventReq in cardObj.canTrigger {
            guard eventReq.match(event: event, actor: player, state: self) else {
                return nil
            }
        }

        return cardObj.onTrigger.map {
            GameAction(
                kind: $0.action,
                payload: .init(
                    actor: player,
                    source: card,
                    target: player,
                    selectors: $0.selectors
                )
            )
        }
    }

    func activatePlayableCards() -> GameAction? {
        guard let player = turn else {
            return nil
        }

        let playerObj = players.get(player)
        let activeCards = (playerObj.abilities + players.get(player).hand)
            .filter {
                GameAction.validatePlay(card: $0, player: player, state: self)
            }

        guard activeCards.isNotEmpty else {
            return nil
        }

        return GameAction.activate(activeCards, player: player)
    }
}

private extension Card.EventReq {
    func match(event: GameAction, actor: String, state: GameState) -> Bool {
        event.kind == actionKind
        && event.payload.target == actor
        && stateConditions.allSatisfy { $0.match(actor: actor, state: state) }
    }
}

private extension GameAction {
    static func validatePlay(card: String, player: String, state: GameState) -> Bool {
        let action = GameAction.play(card, player: player)
        do {
            try action.validate(state: state)
//            print("🟢 validatePlay: \(card)")
            return true
        } catch {
//            print("🛑 validatePlay: \(card)\tthrows: \(error)")
            return false
        }
    }

    func validate(state: GameState) throws {
        var newState = try GameReducer().reduce(state, self)
        if let choice = newState.pendingChoice {
            for option in choice.options {
                let next = GameAction.choose(option.label, player: choice.chooser)
                try next.validate(state: newState)
            }
        } else if newState.queue.isNotEmpty {
            let next = newState.queue.removeFirst()
            try next.validate(state: newState)
        }
    }
}
