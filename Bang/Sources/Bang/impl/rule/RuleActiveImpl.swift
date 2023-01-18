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
        let playableCards = playerObj.hand + playerObj.abilities
        let moves: [Move] = playableCards
            .map { Play(actor: playerId, card: $0.id) }
            .filter { $0.isValid(ctx).isSuccess }
            .compactMap { $0 }
        
        guard !moves.isEmpty else {
            return nil
        }
        
        return moves
    }
}
