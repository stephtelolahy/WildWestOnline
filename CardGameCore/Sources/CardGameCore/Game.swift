//
//  Game.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

import Combine
import Foundation

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
    private var sequences: [SequenceNode]
    
    public init(_ initialState: State, commands: [Move] = [], sequences: [SequenceNode] = []) {
        state = CurrentValueSubject(initialState)
        self.commands = commands
        self.sequences = sequences
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
            let result = command.dispatch(ctx: currState)
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
            let actor = node.actor
            let result = effect.resolve(ctx: currState, actor: actor, selectedArg: node.selectedArg)
            emitEffectResult(result, currState: currState, effect: node.effect, actor: actor)
            return true
        }
        
        /// game idle, process eliminated player and game over
        if isGameOver(ctx: currState) {
            var newState = currState
            newState.isGameOver = true
            state.send(newState)
            return false
        }
        
        /// game idle, process active moves
        if let turn = currState.turn,
           let moves = possibleMoves(actor: turn, ctx: currState) {
            var newState = currState
            newState.decisions[turn] = moves
            state.send(newState)
            return false
        }
        
        return false
    }
    
    /// Generate active moves
    func possibleMoves(actor: String, ctx: State) -> [Move]? {
        let actorObj = ctx.player(actor)
        let moves = (actorObj.inner + actorObj.hand)
            .filter { if case .success = $0.isPlayable(ctx, actor: actor) { return true } else { return false } }
            .map { Play(card: $0.id, actor: actor) }
        
        guard !moves.isEmpty else {
            return nil
        }
        
        return moves
    }
    
    /// Check if game is over
    #warning("implement gameOver rules as effect")
    func isGameOver(ctx: State) -> Bool {
        ctx.players.contains { $0.value.health == 0 }
    }
    
    /// Emit move execution result
    func emitMoveResult(_ result: MoveResult, from currState: State, move: Move) {
        switch result {
        case let .success(aState, nodes, arg):
            if let arg = arg {
                sequences.first?.selectedArg = arg
            }
            if let nodes = nodes {
                sequences.insert(contentsOf: nodes, at: 0)
            }
            
            var newState = aState
            newState.lastEvent = move
            state.send(newState)
            
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.errorMustBeAnEvent(error.localizedDescription))
            }
            
            var newState = currState
            newState.lastEvent = event
            state.send(newState)
        }
    }
    
    /// Emit effect execution result
    func emitEffectResult(_ result: EffectResult, currState: State, effect: Effect, actor: String) {
        switch result {
        case let .success(aState):
            sequences.remove(at: 0)
            var newState = aState
            newState.lastEvent = effect
            state.send(newState)
            
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.errorMustBeAnEvent(error.localizedDescription))
            }
            
            var newState = currState
            newState.lastEvent = event
            sequences.remove(at: 0)
            state.send(newState)
            
        case let .resolving(effects):
            sequences.remove(at: 0)
            let nodes = effects.map { SequenceNode(effect: $0, actor: actor) }
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
                    fatalError(.errorMustBeAnEvent(error.localizedDescription))
                }
                
                var newState = currState
                newState.lastEvent = event
                state.send(newState)
            }
        }
    }
}
