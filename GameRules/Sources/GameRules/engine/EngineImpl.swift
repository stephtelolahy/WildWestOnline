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
    public var queue: [Event]
    private let delay: DispatchTimeInterval
    private let rule: EngineRule
    
    // swiftlint:disable:next function_default_parameter_at_end
    public init(
        _ ctx: Game,
        queue: [Event] = [],
        rule: EngineRule,
        delay: DispatchTimeInterval = .seconds(0)
    ) {
        self.state = CurrentValueSubject(ctx)
        self.queue = queue
        self.rule = rule
        self.delay = delay
    }
    
    public func input(_ move: Move) {
        /// if waiting choice, then validate move
        if let chooseOne = queue.first as? ChooseOne {
            if chooseOne.options.contains(where: { $0.isEqualTo(move) }) {
                queue.remove(at: 0)
            } else {
                return
            }
        }
        
        /// if queue not empty
        else if !queue.isEmpty {
            fatalError(InternalError.unexpected)
        }
        
        queue.insert(move, at: 0)
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
        if let chooseOne = queue.first as? ChooseOne {
            ctx.event = .success(chooseOne)
            state.send(ctx)
            return
        }
        
        // if idle,
        // emit active moves if any
        // then complete
        if queue.isEmpty {
            if let active = rule.active(ctx) {
                ctx.event = .success(Activate(active))
                state.send(ctx)
            }
            return
        }
        
        // remove previous event
        ctx.event = nil
        
        // process queue
        let event = queue.remove(at: 0)
        let result = event.resolve(ctx)
        switch result {
        case let .success(output):
            if let update = output.state {
                ctx = update
                ctx.event = .success(event)
            }
            
            if let cancel = output.cancel {
                if let index = queue.firstIndex(where: { cancel.match($0) }) {
                    queue.remove(at: index)
                    ctx.event = .success(event)
                }
            }
            
            // queue children
            if let children = output.children {
                queue.insert(contentsOf: children, at: 0)
            }
            
            // push triggered effects if any
            if let triggered = rule.triggered(ctx) {
                queue.insert(contentsOf: triggered, at: 0)
            }
            
        case let .failure(error):
            ctx.event = .failure(error)
        }
        
        // emit state only when event occurred
        let emitState = ctx.event != nil
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
