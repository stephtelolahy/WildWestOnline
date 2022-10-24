//
//  Discard.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// discard player's card to discard pile
public struct Discard: Effect {
    let card: String
    let player: String
    let times: String?
    
    public init(card: String, player: String = .PLAYER_ACTOR, times: String? = nil) {
        assert(!card.isEmpty)
        assert(!player.isEmpty)
        
        self.card = card
        self.player = player
        self.times = times
    }
    
    public func resolve(in state: State, ctx: [EffectKey: any Equatable]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copyWithPlayer: { [self] in Discard(card: card, player: $0, times: times) },
                                      ctx: ctx,
                                      state: state)
        }
        
        if let times {
            return Args.resolveNumber(times, copy: { Discard(card: card, player: player) }, ctx: ctx, state: state)
        }
        
        guard Args.isCardResolved(card, source: .player(player), state: state) else {
            return Args.resolveCard(card,
                                    copyWithCard: { Discard(card: $0, player: player) },
                                    chooser: ctx.stringForKey(.ACTOR)!,
                                    source: .player(player),
                                    ctx: ctx,
                                    state: state)
        }
        
        var state = state
        var playerObj = state.player(player)
        
        if let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) {
            let cardObj = playerObj.hand.remove(at: handIndex)
            state.discard.append(cardObj)
        }
        
        if let inPlayIndex = playerObj.inPlay.firstIndex(where: { $0.id == card }) {
            let cardObj = playerObj.inPlay.remove(at: inPlayIndex)
            state.discard.append(cardObj)
        }
        
        state.players[player] = playerObj
        
        return .success(EffectOutput(state: state))
    }
}
