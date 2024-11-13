//
//  StateConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension StateCondition {
    func match(_ state: GameState) throws(GameError) {
        guard matcher.match(state) else {
            throw .noReq(self)
        }
    }
}

private extension StateCondition {
    protocol Matcher {
        func match(_ state: GameState) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .playersAtLeast(let amount): PlayersAtLeast(amount: amount)
        case .playedThisTurnAtMost(let limit): PlayedThisTurnAtMost(limit: limit)
        }
    }

    struct PlayersAtLeast: Matcher {
        let amount: Int

        func match(_ state: GameState) -> Bool {
            state.playOrder.count >= amount
        }
    }

    struct PlayedThisTurnAtMost: Matcher {
        let limit: [String: Int]

        func match(_ state: GameState) -> Bool {
            guard let card = limit.keys.first,
                  let limitPerTurn = limit[card] else {
                return false
            }

            return state.playedThisTurn[card] ?? 0 < limitPerTurn
        }
    }
}
