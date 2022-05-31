//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 01/06/2022.
//

/// Filter to select target player while playing a card
extension Args {
    
    /// select any other player
    static let targetAny = "TARGET_ANY"
    
    /// select any reachable player
    static let targetReachable = "TARGET_REACHABLE"
    
    /// Resolve card target
    static func resolveTarget(_ target: String, ctx: State, actor: String) -> Result<[String]> {
        switch target {
        case targetAny:
            let others = ctx.playOrder.filter { $0 != actor }
            return .success(others)
            
        case targetReachable:
            let weapon = ctx.player(actor).weapon
            let players = ctx.playersAt(weapon, actor: actor)
            guard !players.isEmpty else {
                return .failure(ErrorNoPlayersAtRange(distance: weapon))
            }
            
            return .success(players)
            
        default:
            guard let distance = Int(target) else {
                fatalError(.targetValueInvalid(target))
            }
            
            let players = ctx.playersAt(distance, actor: actor)
            guard !players.isEmpty else {
                return .failure(ErrorNoPlayersAtRange(distance: distance))
            }
            
            return .success(players)
        }
    }
}
