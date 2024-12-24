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
        case .playLimitPerTurn(let limit): PlayLimitPerTurn(limit: limit)
        case .healthZero: HealthZero()
        case .gameOver: GameOver()
        case .currentTurn: CurrentTurn()
        case .draw(let regex): Draw(regex: regex)
        }
    }

    struct PlayersAtLeast: Matcher {
        let amount: Int

        func match(actor: String, state: GameState) -> Bool {
            state.playOrder.count >= amount
        }
    }

    struct PlayLimitPerTurn: Matcher {
        let limit: [String: Int]

        func match(actor: String, state: GameState) -> Bool {
            guard let card = limit.keys.first else {
                fatalError("No card specified in limit")
            }

            let playedThisTurn = state.playedThisTurn[card] ?? 0

            if let actorLimit = state.players.get(actor).playLimitPerTurn[card] {
                return playedThisTurn < actorLimit
            }

            if let requiredLimit = limit[card] {
                return playedThisTurn < requiredLimit
            }

            return false
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

    struct Draw: Matcher {
        let regex: String

        func match(actor: String, state: GameState) -> Bool {
            let drawCardsCount = state.players.get(actor).drawCards
            let drawnCards: [String] = Array(state.discard.prefix(drawCardsCount))
            return drawnCards.contains { $0.matches(regex: regex) }
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
