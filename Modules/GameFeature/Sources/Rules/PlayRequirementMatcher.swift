//
//  PlayRequirementMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension Card.Selector.PlayRequirement {
    func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        matcher.match(pendingAction, state: state)
    }
}

private extension Card.Selector.PlayRequirement {
    protocol Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .not(let req): Not(req: req)
        case .minimumPlayers(let count): MinimumPlayers(count: count)
        case .playLimitsPerTurn(let limits): PlayLimitsPerTurn(limits: limits)
        case .isHealthZero: IsHealthZero()
        case .drawnCardMatches(let regex): DrawnCardMatches(regex: regex)
        case .targetedCardFromHand: TargetedCardFromHand()
        case .targetedCardFromInPlay: TargetedCardFromInPlay()
        case .lastHandCardMatches(let regex): LastHandCardMatches(regex: regex)
        case .isGameOver: IsGameOver()
        case .isCurrentTurn: IsCurrentTurn()
        }
    }

    struct Not: Matcher {
        let req: Card.Selector.PlayRequirement

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            !req.match(pendingAction, state: state)
        }
    }

    struct MinimumPlayers: Matcher {
        let count: Int

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            state.playOrder.count >= count
        }
    }

    struct PlayLimitsPerTurn: Matcher {
        let limits: [String: Int]

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            let player = pendingAction.sourcePlayer
            guard let (card, requiredLimit) = limits.first else {
                fatalError("No card specified in limit")
            }

            let playedCount = state.playedThisTurn[card] ?? 0

            if let playerLimit = state.players.get(player).playLimitsPerTurn[card] {
                return playedCount < playerLimit
            }

            return playedCount < requiredLimit
        }
    }

    struct IsHealthZero: Matcher {
        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            state.players.get(pendingAction.sourcePlayer).health <= 0
        }
    }

    struct DrawnCardMatches: Matcher {
        let regex: String

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            let count = state.lastDrawnCardsCount()
            return state.discard
                .prefix(count)
                .contains { $0.matches(regex: regex) }
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

    struct LastHandCardMatches: Matcher {
        let regex: String

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            let player = pendingAction.sourcePlayer
            guard let card = state.players.get(player).hand.last else {
                fatalError("Missing last card in hand")
            }

            return card.matches(regex: regex)
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

private extension GameFeature.State {
    func lastDrawnCardsCount() -> Int {
        guard let lastDrawIndex = events.lastIndex(where: { $0.name == .draw }) else {
            return 0
        }

        var count = 1
        while events[lastDrawIndex - count].name == .draw {
            count += 1
        }

        return count
    }
}
