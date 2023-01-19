//
//  PlayAction.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

/// Playing action card
struct PlayAction: Move {
    let actor: String
    let card: String
    let target: String?
    
    func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        var ctx = ctx
        var playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
        /// verify can play
        if case let .failure(error) = isValid(ctx) {
            return .failure(error)
        }
        
        /// set playing data
        ctx.played.append(cardObj.name)
        
        /// discard  action card immediately
        guard let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) else {
            fatalError(.unexpected)
        }
        
        playerObj.hand.remove(at: handIndex)
        ctx.discard.append(cardObj)
        ctx.players[actor] = playerObj
        
        /// push child effects
        let children = cardObj.onPlay?.withCtx(playCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    func isValid(_ ctx: Game) -> Result<Void, GameError> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
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
