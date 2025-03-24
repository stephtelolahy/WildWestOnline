//
//  StateReqMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension Card.StateReq {
    func match(player: String, state: GameState) -> Bool {
        matcher.match(player: player, state: state)
    }
}

private extension Card.StateReq {
    protocol Matcher {
        func match(player: String, state: GameState) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .playersAtLeast(let amount): PlayersAtLeast(amount: amount)
        case .playLimitPerTurn(let limit): PlayLimitPerTurn(limit: limit)
        case .healthZero: HealthZero()
        case .gameOver: GameOver()
        case .currentTurn: CurrentTurn()
        case .drawMatching(let regex): DrawMatching(regex: regex)
        case .drawNotMatching(let regex): DrawNotMatching(regex: regex)
        }
    }

    struct PlayersAtLeast: Matcher {
        let amount: Int

        func match(player: String, state: GameState) -> Bool {
            state.playOrder.count >= amount
        }
    }

    struct PlayLimitPerTurn: Matcher {
        let limit: [String: Int]

        func match(player: String, state: GameState) -> Bool {
            guard let card = limit.keys.first else {
                fatalError("No card specified in limit")
            }

            let playedThisTurn = state.playedThisTurn[card] ?? 0

            if let playLimitPerTurn = state.players.get(player).playLimitPerTurn[card] {
                return playedThisTurn < playLimitPerTurn
            }

            if let requiredLimit = limit[card] {
                return playedThisTurn < requiredLimit
            }

            return false
        }
    }

    struct HealthZero: Matcher {
        func match(player: String, state: GameState) -> Bool {
            state.players.get(player).health <= 0
        }
    }

    struct GameOver: Matcher {
        func match(player: String, state: GameState) -> Bool {
            state.playOrder.count <= 1
        }
    }

    struct CurrentTurn: Matcher {
        func match(player: String, state: GameState) -> Bool {
            state.turn == player
        }
    }

    struct DrawMatching: Matcher {
        let regex: String

        func match(player: String, state: GameState) -> Bool {
            let drawCards = state.players.get(player).drawCards
            return state.discard
                .prefix(drawCards)
                .contains { $0.matches(regex: regex) }
        }
    }

    struct DrawNotMatching: Matcher {
        let regex: String

        func match(player: String, state: GameState) -> Bool {
            let drawCards = state.players.get(player).drawCards
            return state.discard
                .prefix(drawCards)
                .allSatisfy { $0.matches(regex: regex) == false }
        }
    }
}

private extension String {
    func matches(regex pattern: String) -> Bool {
        if let regex = try? Regex(pattern),
           ranges(of: regex).isNotEmpty {
            return true
        } else {
            return false
        }
    }
}
