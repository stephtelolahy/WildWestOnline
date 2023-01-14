//
//  EngineImpl.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Combine

public class EngineImpl: Engine {
    
    public var state: CurrentValueSubject<Game, Never>
    
    public var queue: [Effect]
    
    public init(_ ctx: Game, queue: [Effect] = []) {
        self.state = CurrentValueSubject(ctx)
        self.queue = queue
    }
    
    public func start() {
        let ctx = state.value
        
        // verify game already started
        guard ctx.turn == nil else {
            return
        }
        
        let playerId = ctx.playOrder[0]
        queue.append(SetTurn(player: PlayerId(playerId)))
    }
    
    public func input(_ move: Effect) {
        let newCtx = Self.processInput(move, queue: &queue, ctx: state.value)
        state.send(newCtx)
        update()
    }
    
    public func update() {
        let ctx = state.value
        
        // if game is over, do nothing
        if ctx.isOver {
            return
        }
        
        // if waiting player action, do nothing
        guard ctx.options.isEmpty else {
            return
        }
        
        // push triggered moves if any
        let triggered = Rules.main.triggeredMoves(ctx)
        if !triggered.isEmpty {
            let newCtx = Self.processTriggered(triggered, queue: &queue, ctx: ctx)
            state.send(newCtx)
            update()
            return
        }
        
        // if queue empty
        guard !queue.isEmpty else {
            
            // queue active moves if any
            let active = Rules.main.activeMoves(ctx)
            if !active.isEmpty {
                let newCtx = Self.processActive(active, ctx: ctx)
                state.send(newCtx)
            }
            
            return
        }
        
        // process queue
        let newCtx = Self.processQueue(&queue, ctx: ctx)
        state.send(newCtx)
        update()
    }
}

private extension EngineImpl {
    
    /// Update game when a move entered
    static func processInput(_ move: Effect, queue: inout [Effect], ctx: Game) -> Game {
        var ctx = ctx
        
        if !ctx.options.isEmpty {
            // validate move
            // remove options if move is part of them
            let isValid = ctx.options.contains(where: { $0.isEqualTo(move) })
            guard isValid else {
                return ctx
            }
            
            ctx.options.removeAll()
        }
        
        queue.insert(move, at: 0)
        
        ctx.event = nil
        return ctx
    }
    
    /// Disatch next queued effect
    static func processQueue(_ queue: inout [Effect], ctx: Game) -> Game {
        var ctx = ctx
        ctx.event = nil
        let effect = queue.remove(at: 0)
        
        let result = effect.resolve(ctx)
        switch result {
        case let .success(output):
            if let outputState = output.state {
                ctx = outputState
                ctx.event = .success(effect)
            }
            
            if let effects = output.effects {
                queue.insert(contentsOf: effects, at: 0)
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
    
    /// Update game with  triggered effects
    static func processTriggered(_ moves: [Effect], queue: inout [Effect], ctx: Game) -> Game {
        var ctx = ctx
        ctx.event = nil
        queue.insert(contentsOf: moves, at: 0)
        return ctx
    }
    
    /// Update game with  active moves
    static func processActive(_ moves: [Effect], ctx: Game) -> Game {
        var ctx = ctx
        ctx.options = moves
        
        // cleanup
        ctx.currentCard = nil
        ctx.currentActor = nil
        ctx.event = nil
        
        return ctx
    }
}
