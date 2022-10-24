//
//  DrawStore.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//
import CardGameCore

/// Choose some cards from store zone
public struct DrawStore: Effect {
    let card: String
    let player: String
    
    public init(card: String, player: String) {
        assert(!card.isEmpty)
        assert(!player.isEmpty)
        
        self.card = card
        self.player = player
    }
    
    public func resolve(in state: State, ctx: [EffectKey: any Equatable]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copyWithPlayer: { [self] in DrawStore(card: card, player: $0) },
                                      ctx: ctx,
                                      state: state)
        }
        
        guard Args.isCardResolved(card, source: .store, state: state) else {
            return Args.resolveCard(card,
                                    copyWithCard: { DrawStore(card: $0, player: player) },
                                    chooser: player,
                                    source: .store,
                                    ctx: ctx,
                                    state: state)
        }
        
        guard let storeIndex = state.store.firstIndex(where: { $0.id == card }) else {
            fatalError(.storeCardNotFound(card))
        }
        
        var state = state
        var playerObj = state.player(player)
        let cardObj = state.store.remove(at: storeIndex)
        playerObj.hand.append(cardObj)
        state.players[player] = playerObj
        
        return .success(EffectOutput(state: state))
    }
}
