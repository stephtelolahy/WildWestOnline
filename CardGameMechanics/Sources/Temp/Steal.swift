//
//  Steal.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 06/06/2022.
//
import CardGameCore

/// draw some cards from other player
public struct Steal: Effect {
    
    let actor: String
    
    let card: String
    
    let target: String
    
    public init(actor: String = Args.playerActor, card: String, target: String) {
        self.actor = actor
        self.card = card
        self.target = target
    }
    
    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        guard Args.isPlayerResolved(actor, ctx: ctx) else {
            let result = Args.resolvePlayer(target, ctx: ctx, actor: actor)
            switch result {
            case let .success(data):
                switch data {
                case let .identified(pIds),
                    let .selectable(pIds):
                    let options = pIds.map { Steal(actor: actor, card: card, target: $0) }
                    let results: [Result<Void, Error>] = options.map { $0.canResolve(ctx: ctx, actor: actor) }
                    if results.contains(where: { if case .success = $0 { return true } else { return false } }) {
                        return .success
                    } else {
                        return results[0]
                    }
                }
                
            case let .failure(error):
                return .failure(error)
            }
        }
        
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            let result = Args.resolvePlayer(target, ctx: ctx, actor: actor)
            switch result {
            case let .success(data):
                switch data {
                case let .identified(pIds),
                    let .selectable(pIds):
                    let options = pIds.map { Steal(actor: actor, card: card, target: $0) }
                    let results: [Result<Void, Error>] = options.map { $0.canResolve(ctx: ctx, actor: actor) }
                    if results.contains(where: { if case .success = $0 { return true } else { return false } }) {
                        return .success
                    } else {
                        return results[0]
                    }
                }
                
            case let .failure(error):
                return .failure(error)
            }
        }
        
        guard Args.isCardResolved(card, source: .player(target), ctx: ctx) else {
            let result = Args.resolveCard(card, source: .player(target), actor: actor, ctx: ctx)
            switch result {
            case let .success(data):
                switch data {
                case let .identified(cIds),
                    let .selectable(cIds):
                    let options = cIds.map { Steal(actor: actor, card: $0, target: target) }
                    let results: [Result<Void, Error>] = options.map { $0.canResolve(ctx: ctx, actor: actor) }
                    if results.contains(where: { if case .success = $0 { return true } else { return false } }) {
                        return .success
                    } else {
                        return results[0]
                    }
                }
                
            case let .failure(error):
                return .failure(error)
            }
        }
        
        return .success
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        guard Args.isPlayerResolved(actor, ctx: ctx) else {
            return Args.resolvePlayer(actor,
                                      copyWithTarget: { [self] in Steal(actor: $0, card: card, target: target) },
                                      ctx: ctx,
                                      cardRef: cardRef)
        }
        
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithTarget: { [self] in Steal(actor: actor, card: card, target: $0) },
                                      ctx: ctx,
                                      cardRef: cardRef)
        }
        
        guard Args.isCardResolved(card, source: .player(target), ctx: ctx) else {
            return Args.resolveCard(card,
                                    copyWithCard: { Steal(actor: actor, card: $0, target: target) },
                                    actor: ctx.sequence(cardRef).actor,
                                    source: .player(target),
                                    ctx: ctx,
                                    cardRef: cardRef)
        }
        
        var state = ctx
        var actorObj = state.player(actor)
        var targetObj = state.player(target)
        
        if let handIndex = targetObj.hand.firstIndex(where: { $0.id == card }) {
            let cardObj = targetObj.hand.remove(at: handIndex)
            actorObj.hand.append(cardObj)
        }
        
        if let inPlayIndex = targetObj.inPlay.firstIndex(where: { $0.id == card }) {
            let cardObj = targetObj.inPlay.remove(at: inPlayIndex)
            actorObj.hand.append(cardObj)
        }
        
        state.players[actor] = actorObj
        state.players[target] = targetObj
        state.lastEvent = self
        
        return .success(state)
    }
}
