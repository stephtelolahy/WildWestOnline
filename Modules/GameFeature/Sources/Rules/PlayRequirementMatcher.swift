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
        case .playLimitThisTurn(let limit): PlayLimitThisTurn(limit: limit)
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

    struct PlayLimitThisTurn: Matcher {
        let limit: Int

        func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            if pendingAction.contextIgnoreLimitPerTurn > 0 {
                return true
            }

            let cardName = Card.name(of: pendingAction.playedCard)
            var playedCount = 0
            for event in state.eventStack {
                if case .play = event.name {
                    let playedName = Card.name(of: event.playedCard)
                    if playedName == cardName {
                        playedCount += 1
                    }
                } else if case .startTurn = event.name {
                    break
                }
            }

            return playedCount < limit
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
            let count = state.drawnCardsCount()
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
    func drawnCardsCount() -> Int {
        guard let firstIndex = eventStack.firstIndex(where: { $0.name == .draw }) else {
            fatalError("Missing draw event")
        }

        var count = 1
        while eventStack[firstIndex + count].name == .draw {
            count += 1
        }

        return count
    }
}
