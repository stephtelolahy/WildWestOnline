//
//  RuleUpdateImpl.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

extension GameRules: RuleUpdate {
    
    public func update(_ ctx: Game) -> Game {
        var ctx = ctx
        
        ctx.event = nil
        
        var queue = ctx.queue
        let effect = queue.remove(at: 0)
        ctx.queue = queue
        
        let result = effect.resolve(ctx)
        switch result {
        case let .success(output):
            if let outputState = output.state {
                ctx = outputState
                ctx.event = .success(effect)
            }
            
            if let effects = output.effects {
                queue.insert(contentsOf: effects, at: 0)
                ctx.queue = queue
            }
            
            if let options = output.options {
                ctx.decisions = options
            }
            
            return ctx
            
        case let .failure(error):
            ctx.event = .failure(error)
            return ctx
        }
    }
}
