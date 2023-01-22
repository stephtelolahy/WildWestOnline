//
//  PlayAction.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import GameRules

/// Playing action card that will be discarded immediately
struct PlayAction: PlayMode {
    
    func resolve(_ eventCtx: EventContext, ctx: Game) -> Result<Game, Error> {
        /// discard  action card immediately
        var ctx = ctx
        let actor = eventCtx.actor
        var playerObj = ctx.player(eventCtx.actor)
        let cardObj = eventCtx.card
        playerObj.hand.removeAll(where: { $0.id == cardObj.id })
        ctx.discard.append(cardObj)
        ctx.players[actor] = playerObj
        return .success(ctx)
    }
    
    func isValid(_ eventCtx: EventContext, ctx: Game) -> Result<Void, Error> {
        let cardObj = eventCtx.card
        
        /// verify playing effects not empty
        guard cardObj.onPlay != nil else {
            return .failure(GameError.cardHasNoPlayingEffect)
        }
        
        /// verify main effect succeed
        guard let node = cardObj.onPlay?.first?.withCtx(eventCtx) else {
            fatalError(InternalError.unexpected)
        }
        
        if case let .failure(error) = node.resolveUntilCompleted(ctx: ctx) {
            return .failure(error)
        }
        
        return .success
    }
}

private extension Event {
    func resolveUntilCompleted(ctx: Game) -> Result<Void, Error> {
        // handle options: one of them must succeed
        if let chooseOne = self as? ChooseOne {
            let children: [Event] = chooseOne.options.compactMap { move -> Event? in
                if let choose = move as? Choose {
                    if let child0 = choose.children?.first {
                        return child0
                    } else {
                        return nil
                    }
                } else {
                    return move
                }
            }
            
            let results = children.map { $0.resolveUntilCompleted(ctx: ctx) }
            if results.allSatisfy({ $0.isFailure }) {
                return results[0]
            }
            
            return .success
        }
        
        switch resolve(ctx) {
        case let .failure(error):
            return .failure(error)
            
        case let .success(output):
            // update state
            let state = output.state ?? ctx
            
            // handle child effects: one of them must succeed
            if let children = output.children {
                let results = children.map { $0.resolveUntilCompleted(ctx: state) }
                if results.allSatisfy({ $0.isFailure }) {
                    return results[0]
                }
            }
            
            return .success
        }
    }
}
