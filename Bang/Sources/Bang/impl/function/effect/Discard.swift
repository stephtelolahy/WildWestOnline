//
//  Discard.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Discard a player's card to discard pile
/// Actor is the card chooser
public struct Discard: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast private var card: ArgCard
    
    public init(player: ArgPlayer, card: ArgCard) {
        self.player = player
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx) {
                Self(player: PlayerId($0), card: card)
            }
        }
        
        guard let cardId = (card as? CardId)?.id else {
            return resolve(card, ctx: ctx, chooser: ctx.actor, owner: playerId) {
                Self(player: player, card: CardId($0))
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
