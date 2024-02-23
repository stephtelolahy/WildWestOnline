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

    private func distance(from player: String, to other: String) -> Int {
        guard let pIndex = playOrder.firstIndex(of: player),
              let oIndex = playOrder.firstIndex(of: other),
              pIndex != oIndex else {
            return 0
        }

        let pCount = playOrder.count
        let rightDistance = (oIndex > pIndex) ? (oIndex - pIndex) : (oIndex + pCount - pIndex)
        let leftDistance = (pIndex > oIndex) ? (pIndex - oIndex) : (pIndex + pCount - oIndex)
        var distance = min(rightDistance, leftDistance)

        let scope = self.player(player).attributes[.scope] ?? 0
        distance -= scope

        let mustang = self.player(other).attributes[.mustang] ?? 0
        distance += mustang

        return distance
    }
}
