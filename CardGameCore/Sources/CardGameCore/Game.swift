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
    @discardableResult
    func update() -> Bool {
        var currState = state.value
        
        guard !currState.isGameOver else {
            /// game is over, do nothing
            return false
        }
        
        /// process queued command immediately
        if !commands.isEmpty {
            let command = commands.removeFirst()
            currState.lastEvent = nil
            sendResult(command.dispatch(ctx: currState), from: currState)
            return true
        }
        
        guard currState.decisions.isEmpty else {
            /// waiting decision, do nothing
            return false
        }
        
        guard let cardRef = currState.sequences.leaf else {
            /// game idle, process eliminated, check game over
            if isGameOver(ctx: currState) {
                currState.isGameOver = true
                currState.lastEvent = nil
                state.send(currState)
                return false
            }
            
            /// game idle, ask play decision
            if let turn = currState.turn,
               let moves = possibleMoves(actor: turn, ctx: currState) {
                currState.decisions[turn] = Decision(options: moves)
                currState.lastEvent = nil
                state.send(currState)
                return false
            }
            
            return false
        }
        
        var sequence = currState.sequence(cardRef)
        
        guard !sequence.queue.isEmpty else {
            /// queue empty, remove sequence
            currState.sequences.removeValue(forKey: cardRef)
            currState.lastEvent = nil
            state.send(currState)
            return true
        }
        
        /// process queued effect
        let effect = sequence.queue.remove(at: 0)
        currState.sequences[cardRef] = sequence
        currState.lastEvent = nil
        sendResult(effect.resolve(ctx: currState, cardRef: cardRef), from: currState)
        return true
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
    #warning("move into effect")
    func isGameOver(ctx: State) -> Bool {
        ctx.players.contains { $0.value.health == 0 }
    }
    
    func sendResult(_ result: Result<State, Error>, from currState: State) {
        switch result {
        case let .success(successState):
            state.send(successState)
            
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.errorMustBeAnEvent(error.localizedDescription))
            }
            
            var failureState = currState
            failureState.lastEvent = event
            state.send(failureState)
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
