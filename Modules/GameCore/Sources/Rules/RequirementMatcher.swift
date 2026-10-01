//
//  RequirementMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 30/10/2024.
//
extension Card.Selector.Requirement {
    func match(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        switch self {
        case .not(let requirement):
            return !requirement.match(pendingAction, state: state)

        case .playersAtLeast(let count):
            return state.playOrder.count >= count

        case .playLimit(let limit):
            let cardName = Card.name(of: pendingAction.sourceCard)
            let playedCount = state.events
                .prefix { $0.name != .startTurn }
                .count { $0.name == .play && Card.name(of: $0.sourceCard) == cardName }
            return playedCount < limit

        case .isHealthZero:
            return state.players.get(pendingAction.sourcePlayer).health <= 0

        case .drawMatches(let regex):
            return state.discard
                .prefix(state.drawnCardsCount())
                .contains { $0.matches(regex: regex) }

        case .lastDrawnMatches(let regex):
            guard let card = state.players.get(pendingAction.sourcePlayer).hand.last else {
                fatalError("Missing last card in hand")
            }

            return card.matches(regex: regex)

        case .isGameOver:
            return state.playOrder.count <= 1

        case .isMyTurn:
            return state.turn == pendingAction.sourcePlayer
        }
    }
}

private extension String {
    func matches(regex pattern: String) -> Bool {
        guard let regex = try? Regex(pattern) else {
            return false
        }

        return ranges(of: regex).isNotEmpty
    }
}

private extension GameFeature.State {
    func drawnCardsCount() -> Int {
        guard let firstIndex = events.firstIndex(where: { $0.name == .draw }) else {
            fatalError("Missing draw event")
        }

        var count = 1
        while events[firstIndex + count].name == .draw {
            count += 1
        }

        return count
    }
}
