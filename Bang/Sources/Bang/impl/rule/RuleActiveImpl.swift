//
//  RuleActiveImpl.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

extension Rules: RuleActive {
    
    public func activeMoves(_ ctx: Game) -> [Effect] {
        guard let playerId = ctx.turn else {
            return []
        }
        
        let playerObj = ctx.player(playerId)
        let moves: [Effect] = (playerObj.abilities + playerObj.hand)
            .filter { canPlay($0, actor: playerId, in: ctx).isSuccess }
            .map { Play(actor: playerId, card: $0.id) }
            .compactMap { $0 }
        return moves
    }
}
