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
    
    public init(card: String, player: String, otherwise: [Effect], challenger: String? = nil) {
        assert(!card.isEmpty)
        assert(!player.isEmpty)
        assert(!otherwise.isEmpty)
        
        self.card = card
        self.player = player
        self.otherwise = otherwise
        self.challenger = challenger
    }
    
    public func resolve(in state: State, ctx: [EffectKey: any Equatable]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copyWithPlayer: { [self] in ForceDiscard(card: card, player: $0, otherwise: otherwise, challenger: challenger) },
                                      ctx: ctx,
                                      state: state)
        }
        
        // if you cannot discard required card, then apply otherwise effects
        // or if you choosed to pass, then apply otherwise effects
        let playerObj = state.player(player)
        let matchingCards = playerObj.hand.filter { $0.name == card }.map { $0.id }
        if matchingCards.isEmpty || ctx.stringForKey(.SELECTED) == .CHOOSE_PASS {
            return .success(EffectOutput(effects: otherwise, childCtx: [.TARGET: player]))
        }
        
        // request a decision if no card chosen
        guard let chosen = ctx.stringForKey(.SELECTED),
              matchingCards.contains(chosen) else {
            var options: [Move] = matchingCards.map { Choose(value: $0, actor: player) }
            options.append(Choose(value: .CHOOSE_PASS, actor: player))
            return .success(EffectOutput(decisions: options))
        }
        
        // discard card
        var effects: [Effect] = []
        effects.append(Discard(card: chosen, player: player))
        
        // if challenger, toggle target
        if let challenger {
            let toggleEffect = ForceDiscard(card: card, player: challenger, otherwise: otherwise, challenger: player)
            effects.append(toggleEffect)
        }
        
        return .success(EffectOutput(effects: effects))
    }
}
