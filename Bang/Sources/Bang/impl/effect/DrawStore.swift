//
//  DrawStore.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Draw some cards from store zone
public struct DrawStore: Effect, Equatable {
    
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
            return ArgResolverCard.resolve(card, chooser: playerId, ctx: ctx) {
                Self(player: player, card: .id($0))
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
