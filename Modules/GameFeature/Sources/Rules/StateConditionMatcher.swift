//
//  StateConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension Card.Selector.StateCondition {
    func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        matcher.match(pendingAction, state: state)
    }
}

private extension Card.Selector.StateCondition {
    protocol Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .minimumPlayers(let count): MinimumPlayers(count: count)
        case .playLimitPerTurn(let limit): PlayLimitPerTurn(limit: limit)
        case .isGameOver: IsGameOver()
        case .isCurrentTurn: IsCurrentTurn()
        case .isDamagedLethal: IsDamagedLethal()
        case .drawnCardMatches(let regex): DrawnCardMatches(regex: regex)
        case .drawnCardDoesNotMatch(let regex): DrawnCardDoesNotMatch(regex: regex)
        case .targetedCardFromHand: TargetedCardFromHand()
        case .targetedCardFromInPlay: TargetedCardFromInPlay()
        case .targetedPlayerHasHandCard: TargetedPlayerHasHandCard()
        }
    }

    struct MinimumPlayers: Matcher {
        let count: Int

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            state.playOrder.count >= count
        }
    }

    struct PlayLimitPerTurn: Matcher {
        let limit: [String: Int]

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            let player = pendingAction.sourcePlayer
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

    struct IsGameOver: Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            state.playOrder.count <= 1
        }
    }

    struct IsCurrentTurn: Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            state.turn == pendingAction.sourcePlayer
        }
    }

    struct IsDamagedLethal: Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            state.players.get(pendingAction.sourcePlayer).health <= 0
        }
    }

    struct DrawnCardMatches: Matcher {
        let regex: String

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            let player = pendingAction.sourcePlayer
            let drawCards = state.players.get(player).drawCards
            return state.discard
                .prefix(drawCards)
                .contains { $0.matches(regex: regex) }
        }
    }

    struct DrawnCardDoesNotMatch: Matcher {
        let regex: String

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            let player = pendingAction.sourcePlayer
            let drawCards = state.players.get(player).drawCards
            return state.discard
                .prefix(drawCards)
                .allSatisfy { $0.matches(regex: regex) == false }
        }
    }

    struct TargetedCardFromHand: Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            guard let card = pendingAction.targetedCard else { fatalError("Missing targetedCard") }
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            let targetObj = state.players.get(target)
            return targetObj.hand.contains(card)
        }
    }

    struct TargetedCardFromInPlay: Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            guard let card = pendingAction.targetedCard else { fatalError("Missing targetedCard") }
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            let targetObj = state.players.get(target)
            return targetObj.inPlay.contains(card)
        }
    }

    struct TargetedPlayerHasHandCard: Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            let targetObj = state.players.get(target)
            return !targetObj.hand.isEmpty
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
