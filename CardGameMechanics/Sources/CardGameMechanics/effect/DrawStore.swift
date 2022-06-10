//
//  DrawStore.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//
import CardGameCore

/// Choose some cards from store zone
public struct DrawStore: Effect {
    
    private let card: String
    
    private let target: String
    
    public init(card: String, target: String) {
        self.card = card
        self.target = target
    }
    
    public func resolve(ctx: State, actor: String, selectedArg: String?) -> EffectResult {
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in DrawStore(card: card, target: $0) },
                                      ctx: ctx,
                                      actor: actor,
                                      selectedArg: selectedArg)
        }
        
        guard Args.isCardResolved(card, source: .store, ctx: ctx) else {
            return Args.resolveCard(card,
                                    copyWithCard: { DrawStore(card: $0, target: target) },
                                    source: .store,
                                    ctx: ctx,
                                    actor: actor,
                                    selectedArg: selectedArg)
        }
        
        guard let storeIndex = ctx.store.firstIndex(where: { $0.id == card }) else {
            fatalError(.storeCardNotFound(card))
        }
        
        var state = ctx
        var targetObj = state.player(target)
        let cardObj = state.store.remove(at: storeIndex)
        targetObj.hand.append(cardObj)
        state.players[target] = targetObj
        
        return .success(state)
    }
}
