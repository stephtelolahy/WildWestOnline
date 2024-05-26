//
//  GameState+Distance.swift
//  
//
//  Created by Hugues Telolahy on 05/11/2023.
//

extension GameState {
    /// Getting distance between players
    /// The distance between two players is the minimum number of places between them,
    /// counting clockwise or counterclockwise.
    /// When a character is eliminated, he is no longer counted when evaluating the distance:
    /// some players will get "closer" when someone is eliminated.
    func playersAt(_ range: Int, from player: String) -> [String] {
        playOrder
            .filter { $0 != player }
            .filter { distance(from: player, to: $0) <= range }
    }

    private func distance(from playerId: String, to other: String) -> Int {
        guard let pIndex = playOrder.firstIndex(of: playerId),
              let oIndex = playOrder.firstIndex(of: other),
              pIndex != oIndex else {
            return 0
        }

        let pCount = playOrder.count
        let rightDistance = (oIndex > pIndex) ? (oIndex - pIndex) : (oIndex + pCount - pIndex)
        let leftDistance = (pIndex > oIndex) ? (pIndex - oIndex) : (pIndex + pCount - oIndex)
        var distance = min(rightDistance, leftDistance)

        if let magnifying = player(playerId).attributes[.magnifying] {
            distance -= magnifying
        }

        if let remoteness = player(other).attributes[.remoteness] {
            distance += remoteness
        }

        return distance
    }
}
