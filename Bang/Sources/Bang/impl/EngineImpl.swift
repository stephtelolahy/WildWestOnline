//
//  EngineImpl.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Foundation
import Combine

public class EngineImpl: Engine {
    
    public var state: CurrentValueSubject<Game, Never>
    public var queue: [EffectNode]
    private var delay: DispatchTimeInterval
    
    public init(_ ctx: Game, queue: [EffectNode] = [], delay: DispatchTimeInterval = .seconds(0)) {
        self.state = CurrentValueSubject(ctx)
        self.queue = queue
        self.delay = delay
    }
    
    public func start() {
        let ctx = state.value
        
        // if game already started then return
        guard ctx.turn == nil else {
            return
        }
        
        let playerId = ctx.playOrder[0]
        let node = SetTurn(player: PlayerId(playerId)).asNode()
        queue.append(node)
    }
    
    public func input(_ move: Effect) {
        let ctx = state.value
        
        // if waiting choice, then validate move
        if !ctx.options.isEmpty,
           !ctx.options.contains(where: { $0.effect.isEqualTo(move) }) {
            return
        }
        
        let node = move.asNode()
        queue.insert(node, at: 0)
        update()
    }
    
    public func update() {
        _update(state.value)
    }
    
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    private func _update(_ ctx: Game) {
        var ctx = ctx
        
        // if game is over, do nothing
        if ctx.isOver {
            return
        }
        
        // if waiting choice, then verify queue
        if !ctx.options.isEmpty {
            // if matching move queued, remove all options
            guard let node = queue.first,
                  ctx.options.contains(where: { $0.effect.isEqualTo(node.effect) }) else {
                return
            }
            
            ctx.options.removeAll()
        }
        
        // if idle, emit active moves if any
        if queue.isEmpty {
            if let active = Rules.main.activeMoves(ctx) {
                ctx.active = active
                state.send(ctx)
            }
            
            return
        }
        
        // remove previous event
        if ctx.event != nil {
            ctx.event = nil
        }
        
        // remove active moves
        ctx.active.removeAll()
        
        // process queue
        let node = queue.remove(at: 0)
        let effect = node.effect
        let result = effect.resolve(ctx, playCtx: node.playCtx)
        switch result {
        case let .success(output):
            if let update = output.state {
                ctx = update
                ctx.event = .success(effect)
                
                // push triggered moves if any
                if let triggered = Rules.main.triggeredEffects(ctx) {
                    queue.insert(contentsOf: triggered, at: 0)
                }
            }
            
            if let children = output.effects {
                queue.insert(contentsOf: children, at: 0)
            }
            
            if let options = output.options {
                ctx.options = options
            }
            
        case let .failure(error):
            ctx.event = .failure(error)
        }
        
        // emit state only when event ocurred or choice asked
        let emitState = ctx.event != nil || !ctx.options.isEmpty
        if emitState {
            state.send(ctx)
        }
        
        // loop update
        if emitState {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?._update(ctx)
            }
        } else {
            _update(ctx)
        }
    }
}
