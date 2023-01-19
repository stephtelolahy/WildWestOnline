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
    
    public init(actor: String, card: String, target: String? = nil) {
        self.actor = actor
        self.card = card
        self.target = target
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
        /// resolve playTarget if any
        if let playTarget = cardObj.playTarget,
           target == nil {
            return resolve(playTarget, ctx: ctx, playCtx: playCtx) {
                Self(actor: actor, card: card, target: $0)
            }
        }
        
        return implementationByCard(cardObj).resolve(ctx)
    }
    
    public func isValid(_ ctx: Game) -> Result<Void, GameError> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
        /// verify at leat one playTarget succeed if any
        if let playTarget = cardObj.playTarget,
           playCtx.target == nil {
            switch playTarget.resolve(ctx, playCtx: playCtx) {
            case let .failure(error):
                return .failure(error)
                
            case let .success(output):
                guard case let .selectable(options) = output else {
                    fatalError(.unexpected)
                }
                
                let results: [Result<Void, GameError>] = options.map {
                    let copy = Self(actor: actor, card: card, target: $0.value)
                    return copy.isValid(ctx)
                }
                
                if results.allSatisfy({ $0.isFailure }) {
                    return results[0]
                }
                
                return .success
            }
        }
        
        return implementationByCard(cardObj).isValid(ctx)
    }
}

private extension Play {
    func implementationByCard(_ cardObj: Card) -> Move {
        switch cardObj.type {
        case .action:
            return PlayAction(actor: actor, card: card, target: target)
            
        case .equipment:
            return PlayEquipment(actor: actor, card: card)
            
        case .handicap:
            return PlayHandicap(actor: actor, card: card, target: target)
            
        case .ability:
            return PlayAbility(actor: actor, card: card, target: target)
        }
    }
}

private extension Move {
    
    func resolve(
        _ player: ArgPlayer,
        ctx: Game,
        playCtx: PlayContext,
        copy: @escaping (String) -> Self
    ) -> Result<EventOutput, GameError> {
        switch player.resolve(ctx, playCtx: playCtx) {
        case let .failure(error):
            return .failure(error)
            
        case let .success(output):
            guard case let .selectable(options) = output else {
                fatalError(.unexpected)
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
