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
        playCtx: PlayContext,
        copy: @escaping (String) -> Self
    ) -> Result<EffectOutput, GameError> {
        let result = player.resolve(ctx, playCtx: playCtx)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0).withCtx(playCtx) }
                return .success(EffectOutputImpl(children: children))
                
            case let .selectable(items):
                let options: [Choose] = items.map {
                    Choose(player: playCtx.actor,
                           label: $0.label,
                           children: [copy($0.value).withCtx(playCtx)])
                }
                let children = [ChooseOne(options).asNode()]
                return .success(EffectOutputImpl(children: children))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func resolve(
        _ card: ArgCard,
        ctx: Game,
        playCtx: PlayContext,
        chooser: String,
        owner: String?,
        copy: @escaping (String) -> Self
    ) -> Result<EffectOutput, GameError> {
        let result = card.resolve(ctx, chooser: chooser, owner: owner)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0).withCtx(playCtx) }
                return .success(EffectOutputImpl(children: children))
                
            case let .selectable(items):
                let options: [Choose] = items.map {
                    Choose(player: chooser,
                           label: $0.label,
                           children: [copy($0.value).withCtx(playCtx)])
                }
                let children = [ChooseOne(options).asNode()]
                return .success(EffectOutputImpl(children: children))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
}
