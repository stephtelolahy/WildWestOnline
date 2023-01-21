//
//  Effect+Extensions.swift
//
//
//  Created by Hugues Telolahy on 12/01/2023.
//

public extension Effect {

    func resolve(
        _ player: ArgPlayer,
        ctx: Game,
        copy: @escaping (String) -> Self
    ) -> Result<EventOutput, GameError> {
        let result = player.resolve(ctx, playCtx: playCtx)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0).withCtx(playCtx) }
                return .success(EventOutputImpl(children: children))
                
            case let .selectable(items):
                let options: [Choose] = items.map {
                    Choose(actor: playCtx.actor,
                           label: $0.label,
                           children: [copy($0.value).withCtx(playCtx)])
                }
                return .success(EventOutputImpl(children: [ChooseOne(options)]))
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
    ) -> Result<EventOutput, GameError> {
        let result = card.resolve(ctx, playCtx: playCtx, chooser: chooser, owner: owner)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0).withCtx(playCtx) }
                return .success(EventOutputImpl(children: children))
                
            case let .selectable(items):
                let options: [Choose] = items.map {
                    Choose(actor: chooser,
                           label: $0.label,
                           children: [copy($0.value).withCtx(playCtx)])
                }
                return .success(EventOutputImpl(children: [ChooseOne(options)]))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
}
