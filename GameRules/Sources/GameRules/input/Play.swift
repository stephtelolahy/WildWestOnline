//
//  Play.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Play a card
public struct Play: Move, Equatable {
    public let actor: String
    private let card: String
    private let target: String?
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(actor: String, card: String, target: String? = nil) {
        self.actor = actor
        self.card = card
        self.target = target
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let eventCtx = EventContextImpl(actor: actor, card: cardObj, target: target)
        
        /// resolve playTarget if any
        if let playTarget = cardObj.playTarget,
           target == nil {
            return resolve(playTarget, ctx: ctx, eventCtx: eventCtx) {
                Self(actor: actor, card: card, target: $0)
            }
        }
        
        guard let playMode = cardObj.playMode else {
            return .failure(EngineError.cannotPlayThisCard)
        }
        
        return playMode.resolve(eventCtx, ctx: ctx)
            .flatMap {
                /// verify can play
                if case let .failure(error) = isValid(ctx) {
                    return .failure(error)
                }
                
                /// save played
                var newCtx = $0
                newCtx.played.append(cardObj.name)
                
                /// push child effects
                let children = cardObj.onPlay?.withCtx(eventCtx)
                
                return .success(EventOutputImpl(state: newCtx, children: children))
            }
    }
    
    func isValid(_ ctx: Game) -> Result<Void, Error> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let eventCtx = EventContextImpl(actor: actor, card: cardObj, target: target)
        
        /// verify at leat one playTarget succeed if any
        if let playTarget = cardObj.playTarget,
           eventCtx.target == nil {
            switch playTarget.resolve(ctx, eventCtx: eventCtx) {
            case let .failure(error):
                return .failure(error)
                
            case let .success(output):
                guard case let .selectable(options) = output else {
                    fatalError(InternalError.unexpected)
                }
                
                let results: [Result<Void, Error>] = options.map {
                    let copy = Self(actor: actor, card: card, target: $0.value)
                    return copy.isValid(ctx)
                }
                
                if results.allSatisfy({ $0.isFailure }) {
                    return results[0]
                }
                
                return .success
            }
        }
        
        guard let playMode = cardObj.playMode else {
            return .failure(EngineError.cannotPlayThisCard)
        }
        
        return playMode.isValid(eventCtx, ctx: ctx)
            .flatMap { _ in
                
                /// verify all requirements
                if let playReqs = cardObj.canPlay {
                    for playReq in playReqs {
                        if case let .failure(error) = playReq.match(ctx, eventCtx: eventCtx) {
                            return .failure(error)
                        }
                    }
                }
                
                return .success
            }
    }
}

private extension Play {
    func resolve(
        _ player: ArgPlayer,
        ctx: Game,
        eventCtx: EventContext,
        copy: @escaping (String) -> Self
    ) -> Result<EventOutput, Error> {
        switch player.resolve(ctx, eventCtx: eventCtx) {
        case let .failure(error):
            return .failure(error)
            
        case let .success(output):
            guard case let .selectable(options) = output else {
                fatalError(InternalError.unexpected)
            }
            
            let choices: [Choose] = options.map {
                Choose(actor: actor,
                       label: $0.label,
                       children: [copy($0.value)])
            }
            return .success(EventOutputImpl(children: [ChooseOne(choices)]))
        }
    }
}
