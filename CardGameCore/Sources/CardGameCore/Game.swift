//
//  File.swift
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
    
    /// loop update
    func loopUpdate()
}

public class Game: GameProtocol {
    
    public var state: CurrentValueSubject<State, Never>
    
    /// commands queue
    private var commands: [Move] = []
    
    /// initialize game
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
            if let newState = command.dispatch(ctx: currState) {
                state.send(newState)
            }
            return true
        }
        
        guard currState.decisions.isEmpty else {
            /// waiting decision, do nothing
            return false
        }
        
        guard let cardRef = currState.sequences.leaf else {
            /// game idle
            if isGameOver(ctx: currState) {
                currState.isGameOver = true
                currState.lastEvent = nil
                state.send(currState)
                return false
            }
            
            if let turn = currState.turn,
               let moves = possibleMoves(actor: turn, ctx: currState) {
                currState.decisions[turn] = Decision(options: moves)
                state.send(currState)
                return false
            }
            
#warning("Illegal state")
            return false
        }
        
        var sequence = currState.sequence(cardRef)
        
        guard !sequence.queue.isEmpty else {
            /// queued effects completed
            currState.sequences.removeValue(forKey: cardRef)
            currState.lastEvent = nil
            state.send(currState)
            return true
        }
        
        /// process queued effect
        let effect = sequence.queue.remove(at: 0)
        currState.sequences[cardRef] = sequence
        state.send(currState)
        
        if let newState = effect.resolve(ctx: currState, cardRef: cardRef) {
            state.send(newState)
        }
        return true
    }
    
    /// Generate active moves
    func possibleMoves(actor: String, ctx: State) -> [Move]? {
        let actorObj = ctx.player(actor)
        let moves = (actorObj.inner + actorObj.hand)
            .filter { card in card.canPlay.allSatisfy { $0.verify(ctx: ctx, actor: actor, card: card) == nil } }
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
}

private extension Dictionary where Key == String, Value == Sequence {
    
    var leaf: String? {
        first { isLeaf($0.key) }?.key
    }
    
    private func isLeaf(_ key: String) -> Bool {
        allSatisfy { $0.value.parentRef != key }
    }
}
