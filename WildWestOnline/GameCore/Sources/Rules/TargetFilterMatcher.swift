//
//  TargetFilterMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.TargetFilter {
    func match(_ player: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
        matcher.match(player, state: state, ctx: ctx)
    }
}

private extension Card.Selector.TargetFilter {
    protocol Matcher {
        func match(_ player: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .hasCards: HasCards()
        case .atDistance(let distance): AtDistance(distance: distance)
        case .reachable: Reachable()
        }
    }

    struct HasCards: Matcher {
        func match(_ player: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
            let playerObj = state.players.get(player)
            if player == ctx.target {
                return playerObj.inPlay.isNotEmpty
            } else {
                return playerObj.inPlay.isNotEmpty || playerObj.hand.isNotEmpty
            }
        }
    }

    struct AtDistance: Matcher {
        let distance: Int

        func match(_ player: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
            state.distance(from: ctx.player, to: player) <= distance
        }
    }

    struct Reachable: Matcher {
        func match(_ player: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
            state.distance(from: ctx.player, to: player) <= state.players.get(ctx.player).weapon
        }
    }
}

extension GameFeature.State {
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
