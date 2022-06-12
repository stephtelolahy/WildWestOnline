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
    
    /// played cards sequences, last played card is on the top
    /// A Sequence is what begins when a Player Action is taken.
    /// Consists of one or more Effects that are resolved in order.
    private var sequences: [SequenceNode] = []
    
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
        
        /// process leaf sequence
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
        
        /// game idle, process active moves
        if let turn = currState.turn,
           let moves = activeMoves(actor: turn, state: currState) {
            var newState = currState
            newState.decisions[turn] = moves
            state.send(newState)
            return false
        }
        
        return false
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
    
    /// Check if game is over
    func isGameOver(state: State) -> Bool {
        state.players.contains { $0.value.health == 0 }
    }
    
    /// Emit move execution result
    func emitMoveResult(_ result: MoveResult, from currState: State, move: Move) {
        switch result {
        case let .success(aState, effects, arg):
            /// assume selected arg is for the first effect
            if let arg = arg {
                sequences.first?.ctx.selectedArg = arg
            }
            if let effects = effects {
                let ctx = PlayContext(actor: move.actor)
                let nodes = effects.map { SequenceNode(effect: $0, ctx: ctx) }
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
            guard let event = error as? Event else {
                fatalError(.errorTypeInvalid(error.localizedDescription))
            }
            
            var newState = currState
            newState.lastEvent = event
            sequences.remove(at: 0)
            state.send(newState)
            
        case let .resolving(effects),
            let .transformed(effects):
            sequences.remove(at: 0)
            let nodes = effects.map { SequenceNode(effect: $0, ctx: ctx) }
            sequences.insert(contentsOf: nodes, at: 0)
            
        case let .suspended(decisions):
            var newState = currState
            newState.decisions = decisions
            state.send(newState)
            
        case let .remove(filter, error):
            sequences.remove(at: 0)
            
            if let indexToRemove = sequences.firstIndex(where: { filter($0.effect) }) {
                sequences.remove(at: indexToRemove)
                var newState = currState
                newState.lastEvent = effect
                state.send(newState)
            } else {
                guard let event = error as? Event else {
                    fatalError(.errorTypeInvalid(error.localizedDescription))
                }
                
                var newState = currState
                newState.lastEvent = event
                state.send(newState)
            }
            
        case .nothing:
            sequences.remove(at: 0)
        }
    }
}

private struct SequenceNode {
    
    /// effect to be resolved
    let effect: Effect
    
    /// all data about effect resolution
    let ctx: PlayContext
}
