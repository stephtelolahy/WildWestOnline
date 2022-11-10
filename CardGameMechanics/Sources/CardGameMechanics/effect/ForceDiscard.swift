//
//  ForceDiscard.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 10/06/2022.
//
// swiftlint:disable identifier_name

import CardGameCore

/// Player must discard a specific card. If cannot, then apply some effects
/// A challenger can be set to discard himself after target successfully discards a card
public struct ForceDiscard: Effect {
    let card: String
    let player: String
    let otherwise: [Effect]
    let challenger: String?
    public var ctx: [String: Any]
    
    public init(card: String, player: String, otherwise: [Effect], challenger: String? = nil, ctx: [String: Any] = [:]) {
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
        if matchingCards.isEmpty || ctx.booleanForKey(.CTX_PASS) == true {
            // update otherwise effects with current context and targeted player
            let otherwiseWithCtx = otherwise.map {
                var copy = $0
                copy.ctx = ctx
                copy.ctx[.CTX_TARGET] = player
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
        var options: [Move] = matchingCards.map { Select(value: $0, actor: player, effects: [Discard(card: $0, player: player)] + toggle) }
        var pass = self
        pass.ctx[.CTX_PASS] = true
        options.append(Select(value: nil, actor: player, effects: [pass]))
        
        return .success(EffectOutput(options: options))
    }
}

public extension String {
    
    /// previous effect's target
    static let CTX_TARGET = "TARGET"
    
    /// pass the effect
    /// choose to not counter card effect
    static let CTX_PASS = "PASS"
}
