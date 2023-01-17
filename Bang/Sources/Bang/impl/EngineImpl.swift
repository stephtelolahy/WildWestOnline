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
        /// if waiting choice, then validate move
        if let chooseOne = queue.first?.effect as? ChooseOne {
            if chooseOne.getOptions().contains(where: { $0.isEqualTo(move) }) {
                queue.remove(at: 0)
            } else {
                return
            }
        }
        
        /// if queue not empty
        else if !queue.isEmpty {
            fatalError(.unexpected)
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
        
        // if game is over
        // then complete
        if ctx.isOver {
            return
        }
        
        // if waiting choice
        // emit options
        // then complete
        if let chooseOne = queue.first?.effect as? ChooseOne {
            ctx.event = .success(chooseOne)
            state.send(ctx)
            return
        }
        
        // if idle,
        // emit active moves if any
        // then complete
        if queue.isEmpty {
            if let active = Rules.main.activeMoves(ctx) {
                ctx.event = .success(Activate(active))
                state.send(ctx)
            }
            return
        }
        
        // remove previous event
        ctx.event = nil
        
        // process queue
        let node = queue.remove(at: 0)
        let effect = node.effect
        let result = effect.resolve(ctx, playCtx: node.playCtx)
        switch result {
        case let .success(output):
            if let update = output.state {
                ctx = update
                ctx.event = .success(effect)
            }
            
            if let children = output.children {
                queue.insert(contentsOf: children, at: 0)
            }
            
            // push triggered moves if any
            if let triggered = Rules.main.triggeredEffects(ctx) {
                queue.insert(contentsOf: triggered, at: 0)
            }
            
        case let .failure(error):
            ctx.event = .failure(error)
        }
        
        #if DEBUG
        var eventDesc = ""
        if case let .success(effect) = ctx.event {
            eventDesc = String(describing: effect)
        }
        let queueDesc = queue.map { String(describing: $0.effect) }.joined(separator: "\n")
        print("\nevent=\(eventDesc)\nqueue=\n\(queueDesc)")
        #endif
        
        // emit state only when event occurred or choice asked
        let emitState = ctx.event != nil || queue.first?.effect is ChooseOne
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
