//
//  ArgResolverCard.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

enum ArgResolverCard {
    
    /// Resolve card argument
    /// - Parameters:
    ///   - card: card definition
    ///   - owner: player owning the card if any
    ///   - chooser: player making choice
    ///   - ctx: game
    ///   - copy: child effect template
    static func resolve(
        _ card: ArgCard,
        owner: String?,
        chooser: String,
        ctx: Game,
        copy: @escaping (String) -> Effect
    ) -> Result<EffectOutput, GameError> {
        
        switch resolve(card, owner: owner, chooser: chooser, ctx: ctx) {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0) }
                return .success(EffectOutputImpl(effects: children))
                
            case let .selectable(cIds):
                let options = cIds.map { Choose(actor: chooser, value: $0, effects: [copy($0)]) }
                return .success(EffectOutputImpl(options: options))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
}

private extension ArgResolverCard {
    
    static func resolve(
        _ card: ArgCard,
        owner: String?,
        chooser: String,
        ctx: Game
    ) -> Result<ArgResolved, GameError> {
        switch card {
        case let .select(zone):
            
            switch zone {
            case .store:
                return resolveSelectStore(chooser: chooser, ctx: ctx)
                
            case .hand:
                return resolveSelectHand(owner: owner, chooser: chooser, ctx: ctx)
                
            default:
                fatalError("unimplemented resolver for zone \(zone)")
            }
            
        default:
            fatalError("unimplemented resolver for card \(card)")
        }
    }
    
    static func resolveSelectStore(chooser: String, ctx: Game) -> Result<ArgResolved, GameError> {
        let cards = ctx.store.map(\.id)
        guard !cards.isEmpty else {
            return .failure(.noCardInStore)
        }
        
        if cards.count == 1 {
            return .success(.identified(cards))
        }
        
        return .success(.selectable(cards))
    }
    
    static func resolveSelectHand(owner: String?, chooser: String, ctx: Game) -> Result<ArgResolved, GameError> {
        guard let playerId = owner else {
            fatalError(.missingCardOwner)
        }
        
        let playerObj = ctx.player(playerId)
        let cards = playerObj.hand.map(\.id)
        guard !cards.isEmpty else {
            return .failure(.playerHasNoCard(playerId))
        }
        
        return .success(.selectable(cards))
    }
}
