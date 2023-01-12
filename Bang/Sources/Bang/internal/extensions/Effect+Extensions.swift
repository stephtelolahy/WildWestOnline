//
//  Effect+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

extension Effect {
    
    func resolve(
        _ player: ArgPlayer,
        ctx: Game,
        copy: @escaping (String) -> Self
    ) -> Result<EffectOutput, GameError> {
        
        let result = player.resolve(ctx)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0) }
                return .success(EffectOutputImpl(effects: children))
                
            case let .selectable(items):
                let options = items.map { Choose(actor: ctx.actor, label: $0.label, effects: [copy($0.value)]) }
                return .success(EffectOutputImpl(options: options))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func resolve(
        _ card: ArgCard,
        ctx: Game,
        chooser: String,
        owner: String?,
        copy: @escaping (String) -> Self
    ) -> Result<EffectOutput, GameError> {
        
        let result = card.resolve(ctx, chooser: chooser, owner: owner)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0) }
                return .success(EffectOutputImpl(effects: children))
                
            case let .selectable(items):
                let options = items.map { Choose(actor: chooser, label: $0.label, effects: [copy($0.value)]) }
                return .success(EffectOutputImpl(options: options))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
}
