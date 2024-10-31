//
//  TargetConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.TargetCondition {
    func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool {
        matcher.match(player, state: state, ctx: ctx)
    }
}

private extension ActionSelector.TargetCondition {
    protocol Matcher {
        func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .havingCard: HavingCard()
        }
    }

    struct HavingCard: Matcher {
        func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool {
            let playerObject = state.players.get(player)
            if player == ctx.actor {
                return playerObject.inPlay.isNotEmpty
            } else {
                return playerObject.inPlay.isNotEmpty || playerObject.hand.isNotEmpty
            }
        }
    }
}
