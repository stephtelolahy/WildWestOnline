//
//  StateConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension ActionSelector.StateCondition {
    func match(_ state: GameState) throws(GameError) {
        guard matcher.match(state) else {
            throw .noReq(self)
        }
    }
}

private extension ActionSelector.StateCondition {
    protocol Matcher {
        func match(_ state: GameState) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .playersAtLeast(let amount): PlayersAtLeast(amount: amount)
        }
    }

    struct PlayersAtLeast: Matcher {
        let amount: Int

        func match(_ state: GameState) -> Bool {
            state.playOrder.count >= amount
        }
    }
}
