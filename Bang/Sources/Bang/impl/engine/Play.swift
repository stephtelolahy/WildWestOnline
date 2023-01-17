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
        var ctx = ctx
        var playerObj = ctx.player(actor)
        
        /// find card reference
        let cardObj: Card
        if let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) {
            /// discard played card immediately
            cardObj = playerObj.hand.remove(at: handIndex)
            var discard = ctx.discard
            discard.append(cardObj)
            ctx.discard = discard
            ctx.players[actor] = playerObj
            
        } else if let abilityIndex = playerObj.abilities.firstIndex(where: { $0.id == card }) {
            cardObj = playerObj.abilities[abilityIndex]
            
        } else {
            fatalError(.missingPlayerCard(card))
        }
        
        /// set playing data
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
        /// resolve playTarget if any
        if let playTarget = cardObj.playTarget,
           target == nil {
            switch playTarget.resolve(ctx, playCtx: playCtx) {
            case let .failure(error):
                return .failure(error)
                
            case let .success(output):
                guard case let .selectable(options) = output else {
                    fatalError(.unexpected)
                }
                
                let choices: [Choose] = options.map {
                    Choose(actor: actor,
                           label: $0.label,
                           children: [Self(actor: actor, card: card, target: $0.value)])
                }
                return .success(EventOutputImpl(children: [ChooseOne(choices)]))
            }
        }
        
        /// verify can play
        if case let .failure(error) = Self.canPlay(playCtx, in: ctx) {
            return .failure(error)
        }
        
        /// set playing data
        ctx.played.append(cardObj.name)
        
        /// push child effects
        let children = cardObj.onPlay.withCtx(playCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
}

extension Play {
    static func canPlay(_ playCtx: PlayContext, in ctx: Game) -> Result<Void, GameError> {
        let card = playCtx.playedCard
        // verify playing effects not empty
        guard !card.onPlay.isEmpty else {
            return .failure(.cardHasNoPlayingEffect)
        }
        
        /// verify at leat one playTarget succeed if any
        if let playTarget = card.playTarget,
           playCtx.target == nil {
            switch playTarget.resolve(ctx, playCtx: playCtx) {
            case let .failure(error):
                return .failure(error)
                
            case let .success(output):
                guard case let .selectable(options) = output else {
                    fatalError(.unexpected)
                }
                
                let results: [Result<Void, GameError>] = options.map {
                    var copy = playCtx
                    copy.target = $0.value
                    return canPlay(copy, in: ctx)
                }
                
                if results.allSatisfy({ $0.isFailure }) {
                    return results[0]
                }
                
                return .success
            }
        }
        
        /// verify all requirements
        for playReq in card.canPlay {
            if case let .failure(error) = playReq.match(ctx, playCtx: playCtx) {
                return .failure(error)
            }
        }
        
        /// verify main effect succeed
        let node = card.onPlay[0].withCtx(playCtx)
        if case let .failure(error) = node.resolveUntilCompleted(ctx: ctx) {
            return .failure(error)
        }
        
        return .success
    }
}

private extension Event {
    
    /// recursively resolve an effect until completed
    func resolveUntilCompleted(ctx: Game) -> Result<Void, GameError> {
        // handle options: one of them must succeed
        if let chooseOne = self as? ChooseOne {
            let children: [Event] = chooseOne.options.map {
                if let choose = $0 as? Choose {
                    return choose.children[0]
                } else {
                    return $0
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
