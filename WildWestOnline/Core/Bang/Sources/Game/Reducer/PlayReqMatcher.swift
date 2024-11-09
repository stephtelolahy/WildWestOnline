//
//  PlayReqMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension PlayReq {
    func match(_ state: GameState) throws(GameError) {
        guard matcher.match(state) else {
            throw .noReq(self)
        }
    }
}

private extension PlayReq {
    protocol Matcher {
        func match(_ state: GameState) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .playersAtLeast(let amount): PlayersAtLeast(amount: amount)
        case .playedThisTurnAtMost(let limit): PlayedBangThisTurnAtMost(limit: limit)
        }
    }

    struct PlayersAtLeast: Matcher {
        let amount: Int

        func match(_ state: GameState) -> Bool {
            state.playOrder.count >= amount
        }
    }

    struct PlayedBangThisTurnAtMost: Matcher {
        let limit: [String: Int]

        func match(_ state: GameState) -> Bool {
            let card = limit.keys.first!
            let limitPerTurn = limit[card]!
            return state.playedThisTurn[card] ?? 0 < limitPerTurn
        }
    }
}
