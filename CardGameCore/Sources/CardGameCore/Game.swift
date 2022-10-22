//
//  Game.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

import Combine

/// The game engine
public protocol GameProtocol {
    
    /// state to be rendered
    var state: CurrentValueSubject<State, Never> { get }
    
    /// input a move
    func input(_ move: Move)
    
    /// loop update until idle or waiting decision
    func loopUpdate()
}

public class Game: GameProtocol {
    
    public var state: CurrentValueSubject<State, Never>
    
    /// commands queue
    private var commands: [Move]
    
    /// effects queue that have to be resolved in order
    private var sequences: [EffectNode] = []
    
    public init(_ initialState: State, commands: [Move] = []) {
        self.state = CurrentValueSubject(initialState)
        self.commands = commands
    }
    
    public func input(_ move: Move) {
        commands.append(move)
        loopUpdate()
    }
    
    public func loopUpdate() {
        var running = false
        repeat {
            running = update()
        } while running
    }
}

private extension Game {
    
    /// Update game
    /// - Returns:
    /// `true` if an update occurred,
    /// `false` if idle or waiting action
    func update() -> Bool {
        var currState = state.value
        currState.lastEvent = nil
        
        /// if game is over, do nothing
        if currState.isGameOver {
            return false
        }
        
        /// process queued command immediately
        if !commands.isEmpty {
            let command = commands.removeFirst()
            let result = command.dispatch(state: currState)
            emitMoveResult(result, from: currState, move: command)
            return true
        }
        
        /// if waiting decision, do nothing
        if !currState.decisions.isEmpty {
            return false
        }
        
        /// process queued effect
        if let node = sequences.first {
            let effect = node.effect
            let ctx = node.ctx
            let result = effect.resolve(state: currState, ctx: ctx)
            emitEffectResult(result, currState: currState, effect: node.effect, ctx: ctx)
            return true
        }
        
        /// game idle, process eliminated player and game over
        if isGameOver(state: currState) {
            var newState = currState
            newState.isGameOver = true
            state.send(newState)
            return false
        }
        
        /// game idle, generate active moves
        if let turn = currState.turn,
           let moves = activeMoves(actor: turn, state: currState) {
            var newState = currState
            newState.decisions = moves
            state.send(newState)
            return false
        }
        
        return false
    }
    
    /// Emit move execution result
    func emitMoveResult(_ result: MoveResult, from currState: State, move: Move) {
        switch result {
        case let .success(aState, effects, arg):
            /// assume selected arg is for the first effect
            if let arg {
                sequences.first?.ctx.selectedArg = arg
            }
            
            if let effects {
                let ctx = PlayContext(actor: move.actor)
                let nodes = effects.map { EffectNode(effect: $0, ctx: ctx) }
                sequences.insert(contentsOf: nodes, at: 0)
            }
            
            var newState = aState
            newState.lastEvent = move
            state.send(newState)
            
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.errorTypeInvalid(error.localizedDescription))
            }
            
            var newState = currState
            newState.lastEvent = event
            state.send(newState)
        }
    }
    
    /// Emit effect execution result
    func emitEffectResult(_ result: EffectResult, currState: State, effect: Effect, ctx: PlayContext) {
        switch result {
        case let .success(aState):
            sequences.remove(at: 0)
            var newState = aState
            newState.lastEvent = effect
            state.send(newState)
            
        case let .failure(error):
            sequences.remove(at: 0)
            guard let event = error as? Event else {
                fatalError(.errorTypeInvalid(error.localizedDescription))
            }
            
            var newState = currState
            newState.lastEvent = event
            state.send(newState)
            
        case let .resolving(effects):
            sequences.remove(at: 0)
            let nodes = effects.map { EffectNode(effect: $0, ctx: ctx) }
            sequences.insert(contentsOf: nodes, at: 0)
            
        case let .suspended(decisions):
            var newState = currState
            newState.decisions = decisions
            state.send(newState)
            
        case let .cancel(filter):
            sequences.remove(at: 0)
            guard let indexToRemove = sequences.firstIndex(where: { filter($0.effect) }) else {
                var newState = currState
                newState.lastEvent = ErrorNoEffectToSilent()
                state.send(newState)
                return
            }

            sequences.remove(at: indexToRemove)
            var newState = currState
            newState.lastEvent = effect
            state.send(newState)
            
        case .nothing:
            sequences.remove(at: 0)
        }
    }
    
    /// Check if game is over
    func isGameOver(state: State) -> Bool {
        state.players.contains { $0.value.health == 0 }
    }
    
    /// Generate active moves
    func activeMoves(actor: String, state: State) -> [Move]? {
        let actorObj = state.player(actor)
        let moves = (actorObj.inner + actorObj.hand)
            .filter { if case .success = $0.isPlayable(state, actor: actor) { return true } else { return false } }
            .map { Play(card: $0.id, actor: actor) }
        
        guard !moves.isEmpty else {
            return nil
        }
        
        return moves
    }
}

private struct EffectNode {
    
    /// effect to be resolved
    let effect: Effect
    
    /// all data about effect resolution
    let ctx: PlayContext
}


public struct ErrorNoEffectToSilent: Error, Event {
}
