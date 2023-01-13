//
//  EngineImpl.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Combine

public struct EngineImpl: Engine {
    
    public var state: CurrentValueSubject<Game, Never>
    
    public init(_ ctx: Game) {
        self.state = CurrentValueSubject(ctx)
    }
    
    public func input(_ move: Effect) {
        var ctx = state.value
        ctx.queue.insert(move, at: 0)
        
        // remove decision if move is part of options
        let isWaiting = ctx.decisions.contains(where: { $0.isEqualTo(move) })
        if isWaiting {
            ctx.decisions.removeAll()
        }
        
        ctx.event = nil
        state.send(ctx)
        
        update()
    }
    
    public func update() {
        let ctx = state.value
        
        // if game is over, do nothing
        if ctx.isOver {
            return
        }
        
        // if waiting decision, do nothing
        guard ctx.decisions.isEmpty else {
            return
        }
        
        // TODO: push triggered moves if any
        
        // if queue empty
        guard !ctx.queue.isEmpty else {
            
            // TODO: cleanup queue data
            
            // TODO: wait active moves
            
            return
        }
        
        // process queue
        let result = GameRules.main.update(ctx)
        state.send(result)
        
        // game updated, then repeat
        update()
    }
}
