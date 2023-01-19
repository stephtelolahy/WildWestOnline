//
//  PlayAction.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

/// Playing action card
public struct PlayAction: PlayMode {
    
    public init() {}
    
    public func resolve(_ playCtx: PlayContext, ctx: Game) -> Result<EventOutput, GameError> {
        let actor =  playCtx.actor
        var playerObj = ctx.player(playCtx.actor)
        let cardObj = playCtx.playedCard
        
        /// verify can play
        if case let .failure(error) = isValid(playCtx, ctx: ctx) {
            return .failure(error)
        }
        
        /// set playing data
        var ctx = ctx
        ctx.played.append(cardObj.name)
        
        /// discard  action card immediately
        guard let handIndex = playerObj.hand.firstIndex(where: { $0.id == cardObj.id }) else {
            fatalError(.unexpected)
        }
        
        playerObj.hand.remove(at: handIndex)
        ctx.discard.append(cardObj)
        ctx.players[actor] = playerObj
        
        /// push child effects
        let children = cardObj.onPlay?.withCtx(playCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    public func isValid(_ playCtx: PlayContext, ctx: Game) -> Result<Void, GameError> {
        let cardObj = playCtx.playedCard
        
        /// verify playing effects not empty
        guard cardObj.onPlay != nil else {
            return .failure(.cardHasNoPlayingEffect)
        }
        
        /// verify all requirements
        if let playReqs = cardObj.canPlay {
            for playReq in playReqs {
                if case let .failure(error) = playReq.match(ctx, playCtx: playCtx) {
                    return .failure(error)
                }
            }
        }
        
        /// verify main effect succeed
        guard let node = cardObj.onPlay?.first?.withCtx(playCtx) else {
            fatalError(.unexpected)
        }
        
        if case let .failure(error) = node.resolveUntilCompleted(ctx: ctx) {
            return .failure(error)
        }
        
        return .success
    }
}

private extension Event {
    func resolveUntilCompleted(ctx: Game) -> Result<Void, GameError> {
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
