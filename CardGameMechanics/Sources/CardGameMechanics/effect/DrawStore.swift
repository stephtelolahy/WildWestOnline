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
    
    public func resolve(state: State, ctx: PlayContext) -> EffectResult {
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in DrawStore(card: card, target: $0) },
                                      state: state,
                                      ctx: ctx)
        }
        
        guard Args.isCardResolved(card, source: .store, state: state) else {
            return Args.resolveCard(card,
                                    copyWithCard: { DrawStore(card: $0, target: target) },
                                    chooser: target,
                                    source: .store,
                                    state: state,
                                    ctx: ctx)
        }
        
        guard let storeIndex = state.store.firstIndex(where: { $0.id == card }) else {
            fatalError(.storeCardNotFound(card))
        }
        
        var state = state
        var targetObj = state.player(target)
        let cardObj = state.store.remove(at: storeIndex)
        targetObj.hand.append(cardObj)
        state.players[target] = targetObj
        
        return .success(state)
    }
}
