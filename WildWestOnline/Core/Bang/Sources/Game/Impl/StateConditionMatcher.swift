//
//  StateConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension StateCondition {
    func match(actor: String, state: GameState) -> Bool {
        matcher.match(actor: actor, state: state)
    }
}

private extension StateCondition {
    protocol Matcher {
        func match(actor: String, state: GameState) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .playersAtLeast(let amount): PlayersAtLeast(amount: amount)
        case .playedThisTurnAtMost(let limit): PlayedThisTurnAtMost(limit: limit)
        case .isHealthZero: IsHealthZero()
        }
    }

    struct PlayersAtLeast: Matcher {
        let amount: Int

        func match(actor: String, state: GameState) -> Bool {
            state.playOrder.count >= amount
        }
    }

    struct PlayedThisTurnAtMost: Matcher {
        let limit: [String: Int]

        func match(actor: String, state: GameState) -> Bool {
            guard let card = limit.keys.first,
                  let limitPerTurn = limit[card] else {
                return false
            }

            return state.playedThisTurn[card] ?? 0 < limitPerTurn
        }
    }

    struct IsHealthZero: Matcher {
        func match(actor: String, state: GameState) -> Bool {
            state.players.get(actor).health <= 0
        }
    }
}