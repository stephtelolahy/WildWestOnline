//
//  ArgResolverPlayer.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import UIKit

protocol ArgResolverPlayer {

    /// resolve player argument
    func resolve(_ player: ArgPlayer, ctx: Game, copy: @escaping (String) -> Effect) -> Result<EffectOutput, GameError>
}

struct ArgResolverPlayerImpl: ArgResolverPlayer {
    
    func resolve(_ player: ArgPlayer, ctx: Game, copy: @escaping (String) -> Effect) -> Result<EffectOutput, GameError> {
        switch player {
        case .actor:
            guard let actor = ctx.data[.actor] as? String else {
                fatalError("missing actor")
            }
            
            let children = [copy(actor)]
            return .success(EffectOutputImpl(effects: children))
            
        default:
            fatalError("unimplemented resolver for player \(player)")
        }
    }
}
