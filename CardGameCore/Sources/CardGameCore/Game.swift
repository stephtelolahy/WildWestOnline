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
            let result = command.dispatch(in: currState)
            handleMoveResult(result, from: currState, move: command)
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
            let result = effect.resolve(in: currState, ctx: ctx)
            handleEffectResult(result, currState: currState, effect: node.effect, ctx: ctx)
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
    
    /// Handle move execution result
    func handleMoveResult(_ result: Result<MoveOutput, Error>, from currState: State, move: Move) {
        switch result {
        case let .success(output):
            /// assume selected arg is for the first effect
            if let arg = output.selectedArg {
                sequences.first?.ctx.selectedArg = arg
            }
            
            if let effects = output.effects {
                let ctx = PlayContext(actor: move.actor)
                let nodes = effects.map { EffectNode(effect: $0, ctx: ctx) }
                sequences.insert(contentsOf: nodes, at: 0)
            }
            
            var newState = output.state
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
    
    /// Handle effect execution result
    func handleEffectResult(_ result: Result<EffectOutput, Error>, currState: State, effect: Effect, ctx: PlayContext) {
        sequences.remove(at: 0)
        
        switch result {
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.errorTypeInvalid(error.localizedDescription))
            }
            
            var newState = currState
            newState.lastEvent = event
            state.send(newState)
            
        case let .success(output):
            var newState = currState
            
            if let updatedState = output.state {
                newState = updatedState
                newState.lastEvent = effect
            }
            
            if let effects = output.effects {
                let nodes = effects.map { EffectNode(effect: $0, ctx: ctx) }
                sequences.insert(contentsOf: nodes, at: 0)
            }
            
            if let decisions = output.decisions {
                sequences.insert(EffectNode(effect: effect, ctx: ctx), at: 0)
                newState.decisions = decisions
            }
            
            if let filter = output.cancel {
                if let indexToRemove = sequences.firstIndex(where: { filter($0.effect) }) {
                    sequences.remove(at: indexToRemove)
                    newState.lastEvent = effect
                } else {
                    newState.lastEvent = ErrorNoEffectToSilent()
                }
            }
            
            state.send(newState)
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

struct ErrorNoEffectToSilent: Error, Event {
}
