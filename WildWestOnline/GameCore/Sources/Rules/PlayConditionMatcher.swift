//
//  PlayConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension Card.PlayCondition {
    func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
        matcher.match(payload, state: state)
    }
}

private extension Card.PlayCondition {
    protocol Matcher {
        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .minimumPlayers(let count): MinimumPlayers(count: count)
        case .playLimitPerTurn(let limit): PlayLimitPerTurn(limit: limit)
        case .isHealthZero: IsHealthZero()
        case .isHealthNonZero: IsHealthNonZero()
        case .isGameOver: IsGameOver()
        case .isCurrentTurn: IsCurrentTurn()
        case .drawnCardMatches(let regex): DrawnCardMatches(regex: regex)
        case .drawnCardDoesNotMatch(let regex): DrawnCardDoesNotMatch(regex: regex)
        case .payloadCardFromTargetHand: PayloadCardFromTargetHand()
        case .payloadCardFromTargetInPlay: PayloadCardFromTargetInPlay()
        }
    }

    struct MinimumPlayers: Matcher {
        let count: Int

        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            state.playOrder.count >= count
        }
    }

    struct PlayLimitPerTurn: Matcher {
        let limit: [String: Int]

        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let player = payload.player
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

    struct IsHealthZero: Matcher {
        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let player = payload.player
            return state.players.get(player).health <= 0
        }
    }

    struct IsHealthNonZero: Matcher {
        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let player = payload.player
            return state.players.get(player).health > 0
        }
    }

    struct IsGameOver: Matcher {
        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            state.playOrder.count <= 1
        }
    }

    struct IsCurrentTurn: Matcher {
        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            state.turn == payload.player
        }
    }

    struct DrawnCardMatches: Matcher {
        let regex: String

        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let player = payload.player
            let drawCards = state.players.get(player).drawCards
            return state.discard
                .prefix(drawCards)
                .contains { $0.matches(regex: regex) }
        }
    }

    struct DrawnCardDoesNotMatch: Matcher {
        let regex: String

        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let player = payload.player
            let drawCards = state.players.get(player).drawCards
            return state.discard
                .prefix(drawCards)
                .allSatisfy { $0.matches(regex: regex) == false }
        }
    }

    struct PayloadCardFromTargetHand: Matcher {
        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let card = payload.card!
            let target = payload.target!
            let targetObj = state.players.get(target)
            return targetObj.hand.contains(card)
        }
    }

    struct PayloadCardFromTargetInPlay: Matcher {
        func match(_ payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let card = payload.card!
            let target = payload.target!
            let targetObj = state.players.get(target)
            return targetObj.inPlay.contains(card)
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
