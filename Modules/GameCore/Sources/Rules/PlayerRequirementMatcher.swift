//
//  PlayerRequirementMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//
extension Card.Selector.PlayerRequirement {
    func match(_ player: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        let playerObj = state.players.get(player)
        let source = pendingAction.sourcePlayer
        switch self {
        case .hasCards:
            return playerObj.inPlay.isNotEmpty || (player != pendingAction.targetedPlayer && playerObj.hand.isNotEmpty)

        case .hasHandCards:
            return playerObj.hand.isNotEmpty

        case .atDistance(let distance):
            return state.distance(from: source, to: player) <= distance

        case .reachable:
            return state.distance(from: source, to: player) <= state.players.get(source).weapon

        case .isWounded:
            return player != source && playerObj.isWounded
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
