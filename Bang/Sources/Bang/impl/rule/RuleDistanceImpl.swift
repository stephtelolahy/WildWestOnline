//
//  RuleDistanceImpl.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

extension Rules: RuleDistance {
    
    public func playersAt(_ distance: Int, from player: String, in ctx: Game) -> [String] {
        // TODO: implement
        ctx.playOrder.filter { $0 != player }
    }
}
