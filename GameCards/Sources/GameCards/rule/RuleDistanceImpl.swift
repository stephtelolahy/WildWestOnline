//
//  RuleDistanceImpl.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

struct RuleDistanceImpl: RuleDistance {
    
    func playersAt(_ range: Int, from player: String, in ctx: Game) -> [String] {
        ctx.playOrder.filter { player != $0 && Self.distance(from: player, to: $0, in: ctx) <= range }
    }
    
    private static func distance(from player: String, to other: String, in ctx: Game) -> Int {
        guard let pIndex = ctx.playOrder.firstIndex(of: player),
              let oIndex = ctx.playOrder.firstIndex(of: other),
              pIndex != oIndex else {
            return 0
        }
        
        let count = ctx.playOrder.count
        let rightDistance = (oIndex > pIndex) ? (oIndex - pIndex) : (oIndex + count - pIndex)
        let leftDistance = (pIndex > oIndex) ? (pIndex - oIndex) : (pIndex + count - oIndex)
        var distance = min(rightDistance, leftDistance)
        distance -= ctx.player(player).scope
        distance += ctx.player(other).mustang
        return distance
    }
}
