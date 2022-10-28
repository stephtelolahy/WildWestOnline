//
//  ForceDiscard.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//
import CardGameCore

/// Player must discard a specific card. If cannot, then apply some effects
/// A challenger can be set to discard himself after target successfully discards a card
public struct ForceDiscard: Effect {
    let card: String
    let player: String
    let otherwise: [Effect]
    let challenger: String?
    public var ctx: [ContextKey: Any]
    
    public init(card: String, player: String, otherwise: [Effect], challenger: String? = nil, ctx: [ContextKey: Any] = [:]) {
        assert(!card.isEmpty)
        assert(!player.isEmpty)
        assert(!otherwise.isEmpty)
        
        self.card = card
        self.player = player
        self.otherwise = otherwise
        self.challenger = challenger
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copy: { ForceDiscard(card: card, player: $0, otherwise: otherwise, challenger: challenger, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        // if you cannot discard required card, then apply otherwise effects
        // or if you choosed to pass, then apply otherwise effects
        let playerObj = state.player(player)
        let matchingCards = playerObj.hand.filter { $0.name == card }.map { $0.id }
        if matchingCards.isEmpty || ctx.booleanForKey(.PASS) == true {
            // update otherwise effects with current context and targeted player
            let otherwiseWithCtx = otherwise.map {
                var copy = $0
                copy.ctx = ctx
                copy.ctx[.TARGET] = player
                return copy
            }
            return .success(EffectOutput(effects: otherwiseWithCtx))
        }
        
        // if challenger, toggle target
        var toggle: [Effect] = []
        if let challenger {
            toggle = [ForceDiscard(card: card, player: challenger, otherwise: otherwise, challenger: player, ctx: ctx)]
        }
        
        // request a decision:
        // - discard one of matching card
        // - or Pass
        var options: [Move] = matchingCards.map { Choose(value: $0, actor: player, effects: [Discard(card: $0, player: player)] + toggle) }
        var pass = self
        pass.ctx[.PASS] = true
        options.append(Choose(value: nil, actor: player, effects: [pass]))
        
        return .success(EffectOutput(options: options))
    }
}
