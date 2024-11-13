//
//  TargetConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.TargetCondition {
    func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool {
        matcher.match(player, state: state, ctx: ctx)
    }
}

private extension Card.Selector.TargetCondition {
    protocol Matcher {
        func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .havingCard: HavingCard()
        case .atDistance(let distance): AtDistance(distance: distance)
        case .reachable: Reachable()
        }
    }

    struct HavingCard: Matcher {
        func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool {
            let playerObject = state.players.get(player)
            if player == ctx.target {
                return playerObject.inPlay.isNotEmpty
            } else {
                return playerObject.inPlay.isNotEmpty || playerObject.hand.isNotEmpty
            }
        }
    }

    struct AtDistance: Matcher {
        let distance: Int

        func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool {
            state.distance(from: ctx.actor, to: player) <= distance
        }
    }

    struct Reachable: Matcher {
        func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool {
            state.distance(from: ctx.actor, to: player) <= state.players.get(ctx.actor).weapon
        }
    }
}

public extension GameState {
    func distance(from playerId: String, to other: String) -> Int {
        guard let pIndex = playOrder.firstIndex(of: playerId),
              let oIndex = playOrder.firstIndex(of: other) else {
            fatalError("missing player \(playerId) and \(other)")
        }

        guard pIndex != oIndex else {
            return 0
        }

        let pCount = playOrder.count
        let rightDistance = (oIndex > pIndex) ? (oIndex - pIndex) : (oIndex + pCount - pIndex)
        let leftDistance = (pIndex > oIndex) ? (pIndex - oIndex) : (pIndex + pCount - oIndex)
        var distance = min(rightDistance, leftDistance)
        distance -= players.get(playerId).magnifying
        distance += players.get(other).remoteness

        return distance
    }
}
