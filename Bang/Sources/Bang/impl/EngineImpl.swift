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
        let newCtx = Self.processInput(move, ctx: state.value)
        state.send(newCtx)
        update()
    }
    
    public func update() {
        let ctx = state.value
        
        // if game is over, do nothing
        if ctx.isOver {
            return
        }
        
        // if waiting, do nothing
        guard ctx.options.isEmpty else {
            return
        }
        
        // push triggered moves if any
        let triggered = GameRules.main.triggeredMoves(ctx)
        if !triggered.isEmpty {
            let newCtx = Self.processTriggered(triggered, ctx: ctx)
            state.send(newCtx)
            update()
            return
        }
        
        // if queue empty
        guard !ctx.queue.isEmpty else {
            // TODO: cleanup queue data
            // TODO: wait active moves
            return
        }
        
        // process queue
        let newCtx = Self.processQueue(ctx)
        state.send(newCtx)
        update()
    }
}

private extension EngineImpl {
    
    /// Update game when a move entered
    static func processInput(_ move: Effect, ctx: Game) -> Game {
        var ctx = ctx
        ctx.queue.insert(move, at: 0)
        
        // remove options if move is part of them
        let isWaiting = ctx.options.contains(where: { $0.isEqualTo(move) })
        if isWaiting {
            ctx.options.removeAll()
        }
        
        ctx.event = nil
        return ctx
    }
    
    /// Disatch next queued effect
    static func processQueue(_ ctx: Game) -> Game {
        var ctx = ctx
        ctx.event = nil
        let effect = ctx.queue.remove(at: 0)
        
        let result = effect.resolve(ctx)
        switch result {
        case let .success(output):
            if let outputState = output.state {
                ctx = outputState
                ctx.event = .success(effect)
            }
            
            if let effects = output.effects {
                ctx.queue.insert(contentsOf: effects, at: 0)
            }
            
            if let options = output.options {
                ctx.options = options
            }
            
            return ctx
            
        case let .failure(error):
            ctx.event = .failure(error)
            return ctx
        }
    }
    
    /// Update game with given triggered effects
    static func processTriggered(_ moves: [Effect], ctx: Game) -> Game {
        var ctx = ctx
        ctx.event = nil
        ctx.queue.insert(contentsOf: moves, at: 0)
        return ctx
    }
}
