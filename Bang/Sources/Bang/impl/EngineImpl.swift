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
        
        // if game already started then return
        guard ctx.turn == nil else {
            return
        }
        
        let playerId = ctx.playOrder[0]
        queue.append(SetTurn(player: PlayerId(playerId)))
    }
    
    public func input(_ move: Effect) {
        let newCtx = Self.processInput(move, queue: &queue, ctx: state.value)
        _update(newCtx)
    }
    
    public func update() {
        _update(state.value)
    }
}

private extension EngineImpl {
    
    func _update(_ ctx: Game) {
        // if game is over, do nothing
        if ctx.isOver {
            return
        }
        
        // if waiting player action, do nothing
        if !ctx.options.isEmpty {
            return
        }
        
        // idle, emit active moves if any
        if queue.isEmpty {
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
            if let update = output.state {
                ctx = update
                ctx.event = .success(effect)
            }
            
            if let children = output.effects {
                queue.insert(contentsOf: children, at: 0)
            }
            
            if let options = output.options {
                ctx.options = options
            }
            
            // push triggered moves if any
            let triggered = Rules.main.triggeredMoves(ctx)
            if !triggered.isEmpty {
                queue.append(contentsOf: triggered)
            }
            
            return ctx
            
        case let .failure(error):
            ctx.event = .failure(error)
            return ctx
        }
    }
    
    /// Update game with  active moves
    static func processActive(_ moves: [Effect], ctx: Game) -> Game {
        var ctx = ctx
        ctx.options = moves
        
        // cleanup
        ctx.currentCard = nil
        ctx.currentActor = nil
        ctx.currentPlayer = nil
        
        return ctx
    }
}
