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
    
    /// event or error to be rendered
    var message: PassthroughSubject<Event, Never> { get }
    
    /// input a move
    func input(_ move: Move)
    
    /// loop update until idle or waiting decision
    func loopUpdate()
}

public class Game: GameProtocol {
    
    public var state: CurrentValueSubject<State, Never>
    
    public var message: PassthroughSubject<Event, Never>
    
    /// commands queue
    private var commands: [Move] = []
    
    public init(_ initialState: State) {
        state = CurrentValueSubject(initialState)
        message = PassthroughSubject()
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
        let currState = state.value
        
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
        if let cardRef = currState.sequences.leaf {
            let sequence = currState.sequence(cardRef)
            let effect = sequence.queue[0]
            let result = effect.resolve(ctx: currState, actor: sequence.actor)
            emitEffectResult(result, currState: currState, cardRef: cardRef, effect: effect)
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
            newState.decisions[turn] = Decision(options: moves)
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
    func isGameOver(ctx: State) -> Bool {
        ctx.players.contains { $0.value.health == 0 }
    }
    
    /// Emit move execution result
    func emitMoveResult(_ result: Result<State, Error>, from currState: State, move: Move) {
        switch result {
        case let .success(aState):
            state.send(aState)
            message.send(move)
            
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.errorMustBeAnEvent(error.localizedDescription))
            }
            
            message.send(event)
        }
    }
    
    /// Emit effect execution result
    func emitEffectResult(_ result: EffectResult, currState: State, cardRef: String, effect: Effect) {
        switch result {
        case let .success(aState):
            var newState = aState.removingFirstEffect(cardRef)
            newState.cleanupSequences()
            state.send(newState)
            message.send(effect)
            
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.errorMustBeAnEvent(error.localizedDescription))
            }
            
            message.send(event)
            var newState = currState.removingFirstEffect(cardRef)
            newState.cleanupSequences()
            state.send(newState)
            
        case let .resolving(effects):
            var newState = currState.removingFirstEffect(cardRef)
            var sequence = newState.sequence(cardRef)
            sequence.queue.insert(contentsOf: effects, at: 0)
            newState.sequences[cardRef] = sequence
            state.send(newState)
            
        case let .suspended(moves):
            fatalError()
        }
    }
}

private extension State {
    
    /// remove first effect in sequence queue and add it as lastEvent
    func removingFirstEffect(_ cardRef: String) -> State {
        var state = self
        var sequence = sequence(cardRef)
        sequence.queue.remove(at: 0)
        state.sequences[cardRef] = sequence
        return state
    }
    
    /// Remove leaf sequences with empty queue
    mutating func cleanupSequences() {
        while true {
            if let cardRef = sequences.leaf,
               sequence(cardRef).queue.isEmpty {
                sequences.removeValue(forKey: cardRef)
            } else {
                break
            }
        }
    }
}

private extension Dictionary where Key == String, Value == Sequence {
    
    var leaf: String? {
        first { isLeaf($0.key) }?.key
    }
    
    private func isLeaf(_ key: String) -> Bool {
        allSatisfy { $0.value.parentRef != key }
    }
}
