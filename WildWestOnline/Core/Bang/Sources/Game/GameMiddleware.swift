//
//  GameMiddleware.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Combine

/// Game loop features
public extension Middlewares {
    static var updateGame: Middleware<GameState> {
        { state, action in
            guard let action = action as? GameAction else {
                return nil
            }

            if let triggered = state.triggeredEffect(on: action) {
                return Just(triggered).eraseToAnyPublisher()
            }

            if let pending = state.pendingEffect() {
                return Just(pending).eraseToAnyPublisher()
            }

            return nil
        }
    }
}

private extension GameState {
    func pendingEffect() -> GameAction? {
        guard queue.isNotEmpty,
              pendingChoice == nil else {
            return nil
        }

        return queue[0]
    }

    func triggeredEffect(on event: GameAction) -> GameAction? {
        var triggered: [GameAction] = []
        for player in playOrder {
            let playerObj = players.get(player)
            let cards = playerObj.inPlay + playerObj.abilities
            for card in cards {
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
                kind: .group,
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

        let testCardRegex = /^c[a-z0-9]/
        let isNotTestCard = cardName.ranges(of: testCardRegex).isEmpty
        guard isNotTestCard else {
            return nil
        }

        guard let cardObj = cards[cardName] else {
            fatalError("Missing definition of \(cardName)")
        }

        guard cardObj.canTrigger.isNotEmpty else {
            return nil
        }

        guard cardObj.canTrigger.allSatisfy({
            $0.match(event: event, actor: player, state: self)
        }) else {
            return nil
        }

        return cardObj.onTrigger.map {
            GameAction(
                kind: $0.action,
                payload: .init(
                    actor: player,
                    target: player,
                    selectors: $0.selectors
                )
            )
        }
    }
}

private extension ActionCondition {
    func match(event: GameAction, actor: String, state: GameState) -> Bool {
        event.kind == kind
        && event.payload.target == actor
        && stateConditions.allSatisfy { $0.match(actor: actor, state: state) }
    }
}
