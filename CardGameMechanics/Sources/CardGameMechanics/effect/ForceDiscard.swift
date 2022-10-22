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
    
    private let card: String
    
    private let target: String
    
    private let challenger: String?
    
    private let otherwise: [Effect]
    
    public init(card: String, target: String, challenger: String? = nil, otherwise: [Effect] = []) {
        self.card = card
        self.target = target
        self.challenger = challenger
        self.otherwise = otherwise
    }
    
    public func resolve(in state: State, ctx: [String: String]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in ForceDiscard(card: card, target: $0, challenger: challenger, otherwise: otherwise) },
                                      state: state,
                                      ctx: ctx)
        }
        
        // you choosed to pass, then apply otherwise effects
        // you cannot discard required card, then apply otherwise effects
        let targetObj = state.player(target)
        let matchingCards = targetObj.hand.filter { $0.name == card }.map { $0.id }
        if matchingCards.isEmpty || ctx[Args.selected] == Args.choosePass {
            return .success(EffectOutput(effects: otherwise, childCtx: [Args.playerTarget: target]))
        }
        
        // request a decision if no card chosen
        guard let chosen = ctx[Args.selected],
                matchingCards.contains(chosen) else {
            var options: [Move] = matchingCards.map { Choose(value: $0, actor: target) }
            options.append(Choose(value: Args.choosePass, actor: target))
            return .success(EffectOutput(decisions: options))
        }
        
        // discard card
        var effects: [Effect] = []
        effects.append(Discard(card: chosen, target: target))
        
        // if challenger, toggle target
        if let challenger {
            let toggleEffect = ForceDiscard(card: card, target: challenger, challenger: target, otherwise: otherwise)
            effects.append(toggleEffect)
        }
        
        return .success(EffectOutput(effects: effects))
    }
}
