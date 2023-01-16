//
//  DrawStore.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Draw some cards from store zone
public struct DrawStore: Effect, Equatable {
    @EquatableCast private var player: ArgPlayer
    @EquatableCast private var card: ArgCard
    
    public init(player: ArgPlayer, card: ArgCard) {
        self.player = player
        self.card = card
    }
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError> {
        guard let playerId = (player as? PlayerId)?.id else {
            return resolve(player, ctx: ctx, playCtx: playCtx) {
                Self(player: PlayerId($0), card: card)
            }
        }
        
        guard let cardId = (card as? CardId)?.id else {
            return resolve(card, ctx: ctx, playCtx: playCtx, chooser: playerId, owner: nil) {
                Self(player: player, card: CardId($0))
            }
        }
        
        guard let storeIndex = ctx.store.firstIndex(where: { $0.id == cardId }) else {
            fatalError(.missingStoreCard(cardId))
        }
        
        var ctx = ctx
        var playerObj = ctx.player(playerId)
        let cardObj = ctx.store.remove(at: storeIndex)
        playerObj.hand.append(cardObj)
        ctx.players[playerId] = playerObj
        
        return .success(EffectOutputImpl(state: ctx))
    }
}
