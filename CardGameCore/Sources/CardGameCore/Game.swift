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
    
    /// loop update
    
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
        var currState = state.value
        
        /// if game is over, do nothing
        if currState.isGameOver {
            return false
        }
        
        /// process queued command immediately
        if !commands.isEmpty {
            let command = commands.removeFirst()
            currState.lastEvent = nil
            let newState = optimalChange(command.dispatch(ctx: currState), from: currState)
            state.send(newState)
            return true
        }
        
        /// if waiting decision, do nothing
        if !currState.decisions.isEmpty {
            return false
        }
        
        /// process leaf sequence
        if let cardRef = currState.sequences.leaf {
            var sequence = currState.sequence(cardRef)
            let effect = sequence.queue.remove(at: 0)
            currState.sequences[cardRef] = sequence
            currState.lastEvent = nil
            let newState = optimalChange(effect.resolve(ctx: currState, cardRef: cardRef), from: currState)
            state.send(newState)
            return true
        }
        
        /// game idle, process eliminated player and game over
        if isGameOver(ctx: currState) {
            currState.isGameOver = true
            currState.lastEvent = nil
            state.send(currState)
            return false
        }
        
        /// game idle, set play decision
        if let turn = currState.turn,
           let moves = possibleMoves(actor: turn, ctx: currState) {
            currState.decisions[turn] = Decision(options: moves)
            currState.lastEvent = nil
            state.send(currState)
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
    
    /// Emit result state or original state with error
    func optimalChange(_ result: Result<State, Error>, from currState: State) -> State {
        switch result {
        case var .success(successState):
            successState.cleanupSequences()
            return successState
            
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.errorMustBeAnEvent(error.localizedDescription))
            }
            
            var failureState = currState
            failureState.cleanupSequences()
            failureState.lastEvent = event
            return failureState
        }
    }
}

private extension State {
    
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
