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
    
    public func resolve(ctx: State, actor: String, selectedArg: String?) -> EffectResult {
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in ForceDiscard(card: card, target: $0, challenger: challenger, otherwise: otherwise) },
                                      ctx: ctx,
                                      actor: actor,
                                      selectedArg: selectedArg)
        }
        
        // you choosed to pass, then apply otherwise effects
        if selectedArg == Args.choosePass {
            return .resolving(otherwise)
        }
        
        // you cannot discard required card, then apply otherwise effects
        let targetObj = ctx.player(target)
        let matchingCards = targetObj.hand.filter { $0.name == card }.map { $0.id }
        if matchingCards.isEmpty {
            return .resolving(otherwise)
        }
        
        // request a decision if no card chosen
        guard let chosen = selectedArg,
                matchingCards.contains(chosen) else {
            var options: [Move] = matchingCards.map { Choose(value: $0, actor: target) }
            options.append(Choose(value: Args.choosePass, actor: target))
            return .suspended([target: options])
        }
        
        // discard card
        var effects: [Effect] = []
        effects.append(Discard(card: chosen, target: target))
        
        // if challenger, toggle target
        if let challenger = self.challenger {
            let toggleEffect = ForceDiscard(card: card, target: challenger, challenger: target, otherwise: otherwise)
            effects.append(toggleEffect)
        }
        
        return .resolving(effects)
    }
}
