//
//  EngineImpl.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Combine

public struct EngineImpl: Engine {
    
    public var state: CurrentValueSubject<Game, Never>
    
    public init(ctx: Game) {
        self.state = CurrentValueSubject(ctx)
    }
    
    public func input(_ move: Effect) {
        var ctx = state.value
        ctx.queue.insert(move, at: 0)
        
        // remove decision if move is part of pending options
        if ctx.isWaiting(move) {
            ctx.decisions.removeAll()
        }
        
        state.send(ctx)
        update()
    }
    
    public func update() {
        var ctx = state.value
        ctx.event = nil
        
        /// if game is over, do nothing
        if ctx.isOver {
            return
        }
        
        /// if waiting decision, do nothing
        guard ctx.decisions.isEmpty else {
            return
        }
        
        /// if queue empty, do nothing
        guard !ctx.queue.isEmpty else {
            return
        }
        
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
            
            state.send(ctx)
            
        case let .failure(error):
            ctx.event = .failure(error)
            state.send(ctx)
        }
        
        /// game updated
        /// repeat
        update()
    }
}

private extension Game {
    
    func isWaiting<T: Effect>(_ move: T) -> Bool {
        decisions.contains(where: {
            guard let option = $0 as? T else {
                return false
            }
            
            // TODO: compare using Equatable
            return String(describing: option) == String(describing: move)
            
        })
    }
}
