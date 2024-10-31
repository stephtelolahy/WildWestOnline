//
//  TargetConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.TargetCondition {
    func match(_ player: String, state: GameState) -> Bool {
        matcher.match(player, state: state)
    }
}

private extension ActionSelector.TargetCondition {
    protocol Matcher {
        func match(_ player: String, state: GameState) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .havingCard: HavingCard()
        }
    }

    struct HavingCard: Matcher {
        func match(_ player: String, state: GameState) -> Bool {
            let playerObject = state.players.get(player)
            return (playerObject.hand.count + playerObject.inPlay.count) > 0
        }
    }
}
