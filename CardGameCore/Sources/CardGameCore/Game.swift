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
    private var commands: [Move] = []
    
    public init(_ initialState: State) {
        state = CurrentValueSubject(initialState)
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
        let currState = state.value.settingLastEvent(nil)
        
        /// if game is over, do nothing
        if currState.isGameOver {
            return false
        }
        
        /// process queued command immediately
        if !commands.isEmpty {
            let command = commands.removeFirst()
            let result = command.dispatch(ctx: currState)
            let newState = mapMoveResult(result, from: currState, move: command)
            state.send(newState)
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
            let newState = mapEffectResult(result, currState: currState, cardRef: cardRef, effect: effect)
            state.send(newState)
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
    
    /// Return optimal `State` from a move execution result
    func mapMoveResult(_ result: Result<State, Error>, from currState: State, move: Move) -> State {
        switch result {
        case let .success(aState):
            assert(aState.lastEvent == nil)
            
            var newState = currState
            newState.lastEvent = move
            return aState
            
        case let .failure(error):
            assert(currState.lastEvent == nil)
            
            guard error is Event else {
                fatalError(.errorMustBeAnEvent(error.localizedDescription))
            }
            
            var newState = currState
            newState.lastEvent = error as? Event
            return newState
        }
    }
    
    /// Return optimal `State` from a effect execution result
    func mapEffectResult(_ result: EffectResult, currState: State, cardRef: String, effect: Effect) -> State {
        switch result {
        case let .success(aState):
            assert(aState.lastEvent == nil)
            
            var newState = aState.removingFirstEffect(cardRef)
            newState.cleanupSequences()
            newState.lastEvent = effect
            return newState
            
        case let .failed(error):
            assert(currState.lastEvent == nil)
            
            var newState = currState.removingFirstEffect(cardRef)
            newState.cleanupSequences()
            newState.lastEvent = error
            return newState
            
        case let .suspended(moves):
            fatalError()
            
        case let .resolving(effects):
            fatalError()
        }
    }
}

private extension State {
    
    /// copy state setting last Event
    func settingLastEvent(_ event: Event?) -> State {
        var state = self
        state.lastEvent = event
        return state
    }
    
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
