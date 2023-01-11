//
//  ArgResolverCard.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

enum ArgResolverCard {
    
    static func resolve(
        _ card: ArgCard,
        chooser: String,
        ctx: Game,
        copy: @escaping (String) -> Effect
    ) -> Result<EffectOutput, GameError> {
        
        switch resolve(card, chooser: chooser, ctx: ctx) {
            
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let effects = cIds.map { copy($0) }
                return .success(EffectOutputImpl(effects: effects))
                
            case let .selectable(cIds):
                let options = cIds.map { Choose(actor: chooser, value: $0, effects: [copy($0)]) }
                return .success(EffectOutputImpl(options: options))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    private static func resolve(
        _ card: ArgCard,
        chooser: String,
        ctx: Game
    ) -> Result<ArgResolved, GameError> {
        switch card {
        case let .select(zone):
            
            switch zone {
            case .store:
                let cards = ctx.store.map(\.id)
                guard !cards.isEmpty else {
                    return .failure(.noCardInStore)
                }
                
                if cards.count == 1 {
                    return .success(.identified(cards))
                }
                
                return .success(.selectable(cards))
                
            default:
                fatalError("unimplemented resolver for zone \(zone)")
            }
            
        default:
            fatalError("unimplemented resolver for card \(card)")
        }
    }
}
