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

        // active players
        for player in playOrder {
            let playerObj = players.get(player)
            let triggerableCards = playerObj.inPlay + playerObj.abilities
            for card in triggerableCards {
                let effects = triggeredEffects(on: event, by: card, player: player)
                triggered.append(contentsOf: effects)
            }
        }

        // return triggered effects
        guard triggered.isNotEmpty else {
            return nil
        }

        guard triggered.count == 1 else {
            fatalError("Unsupported")
        }

        return triggered[0]
    }

    func triggeredEffects(
        on event: GameAction,
        by card: String,
        player: String
    ) -> [GameAction] {
        let cardName = Card.extractName(from: card)
        guard let cardObj = cards[cardName] else {
            fatalError("Missing definition of \(cardName)")
        }

        let ctx = EventReq.MatchingContext(
            event: event,
            card: card,
            actor: player
        )

        return cardObj.onTrigger
            .filter { $0.when.match(ctx, state: self) }
            .map {
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
