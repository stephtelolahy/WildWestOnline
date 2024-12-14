//
//  StateReqMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension Card.StateReq {
    func match(actor: String, state: GameState) -> Bool {
        matcher.match(actor: actor, state: state)
    }
}

private extension Card.StateReq {
    protocol Matcher {
        func match(actor: String, state: GameState) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .playersAtLeast(let amount): PlayersAtLeast(amount: amount)
        case .playedThisTurnAtMost(let limit): PlayedThisTurnAtMost(limit: limit)
        case .healthZero: HealthZero()
        case .gameOver: GameOver()
        case .currentTurn: CurrentTurn()
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

            let playedThisTurn = state.playedThisTurn[card] ?? 0
            return playedThisTurn < limitPerTurn
        }
    }

    struct HealthZero: Matcher {
        func match(actor: String, state: GameState) -> Bool {
            state.players.get(actor).health <= 0
        }
    }

    struct GameOver: Matcher {
        func match(actor: String, state: GameState) -> Bool {
            state.playOrder.count <= 1
        }
    }

    struct CurrentTurn: Matcher {
        func match(actor: String, state: GameState) -> Bool {
            state.turn == actor
        }
    }
}
