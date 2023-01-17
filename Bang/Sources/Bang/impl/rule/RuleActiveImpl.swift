//
//  RuleActiveImpl.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

extension Rules: RuleActive {
    
    public func activeMoves(_ ctx: Game) -> [Move]? {
        guard let playerId = ctx.turn else {
            return nil
        }
        
        let playerObj = ctx.player(playerId)
        let moves: [Play] = (playerObj.abilities + playerObj.hand)
            .filter { Play.canPlay(PlayContextImpl(actor: playerId, playedCard: $0), in: ctx).isSuccess }
            .map { Play(actor: playerId, card: $0.id) }
            .compactMap { $0 }
        
        guard !moves.isEmpty else {
            return nil
        }
        
        return moves
    }
}
