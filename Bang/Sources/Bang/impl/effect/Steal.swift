//
//  Steal.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// draw card from other player
public struct Steal: Effect, Equatable {
    private let player: ArgPlayer
    private let target: ArgPlayer
    private let card: ArgCard
    
    public init(player: ArgPlayer, target: ArgPlayer, card: ArgCard) {
        self.player = player
        self.target = target
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .id(playerId) = player else {
            return ArgResolverPlayer.resolve(player, ctx: ctx) {
                Self(player: .id($0), target: target, card: card)
            }
        }
        
        guard case let .id(targetId) = target else {
            return ArgResolverPlayer.resolve(target, ctx: ctx) {
                Self(player: player, target: .id($0), card: card)
            }
        }
        
        guard case let .id(cardId) = card else {
            return ArgResolverCard.resolve(card, owner: targetId, chooser: playerId, ctx: ctx) {
                Self(player: player, target: target, card: .id($0))
            }
        }
        
        var ctx = ctx
        var playerObj = ctx.player(playerId)
        var targetObj = ctx.player(targetId)
        
        if let handIndex = targetObj.hand.firstIndex(where: { $0.id == cardId }) {
            let cardObj = targetObj.hand.remove(at: handIndex)
            playerObj.hand.append(cardObj)
        }
        
        if let inPlayIndex = targetObj.inPlay.firstIndex(where: { $0.id == cardId }) {
            let cardObj = targetObj.inPlay.remove(at: inPlayIndex)
            playerObj.hand.append(cardObj)
        }
        
        ctx.players[playerId] = playerObj
        ctx.players[targetId] = targetObj
        
        return .success(EffectOutputImpl(state: ctx))
    }
}
