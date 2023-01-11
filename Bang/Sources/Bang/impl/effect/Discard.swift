//
//  Discard.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Discard player's card to discard pile
public struct Discard: Effect, Equatable {
    private let player: ArgPlayer
    private let card: ArgCard
    
    public init(player: ArgPlayer, card: ArgCard) {
        self.player = player
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .id(playerId) = player else {
            return ArgResolverPlayer.resolve(player, ctx: ctx) {
                Self(player: .id($0), card: card)
            }
        }
        
        guard case let .id(cardId) = card else {
            return ArgResolverCard.resolve(card, owner: playerId, chooser: ctx.actor, ctx: ctx) {
                Self(player: player, card: .id($0))
            }
        }
        
        var ctx = ctx
        var playerObj = ctx.player(playerId)
        
        if let handIndex = playerObj.hand.firstIndex(where: { $0.id == cardId }) {
            let cardObj = playerObj.hand.remove(at: handIndex)
            ctx.discard.append(cardObj)
        }
        
        if let inPlayIndex = playerObj.inPlay.firstIndex(where: { $0.id == cardId }) {
            let cardObj = playerObj.inPlay.remove(at: inPlayIndex)
            ctx.discard.append(cardObj)
        }
        
        ctx.players[playerId] = playerObj
        
        return .success(EffectOutputImpl(state: ctx))
    }
}
