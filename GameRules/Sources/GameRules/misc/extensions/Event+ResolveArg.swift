//
//  Event+ResolveArg.swift
//
//
//  Created by Hugues Telolahy on 12/01/2023.
//

public extension Event {

    func resolve(
        _ player: ArgPlayer,
        ctx: Game,
        copy: @escaping (String) -> Self
    ) -> Result<EventOutput, Error> {
        let result = player.resolve(ctx, eventCtx: eventCtx)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0).withCtx(eventCtx) }
                return .success(EventOutputImpl(children: children))
                
            case let .selectable(items):
                let options: [Choose] = items.map {
                    Choose(actor: eventCtx.actor,
                           label: $0.label,
                           children: [copy($0.value).withCtx(eventCtx)])
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
    ) -> Result<EventOutput, Error> {
        let result = card.resolve(ctx, eventCtx: eventCtx, chooser: chooser, owner: owner)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(cIds):
                let children = cIds.map { copy($0).withCtx(eventCtx) }
                return .success(EventOutputImpl(children: children))
                
            case let .selectable(items):
                let options: [Choose] = items.map {
                    Choose(actor: chooser,
                           label: $0.label,
                           children: [copy($0.value).withCtx(eventCtx)])
                }
                return .success(EventOutputImpl(children: [ChooseOne(options)]))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
}
