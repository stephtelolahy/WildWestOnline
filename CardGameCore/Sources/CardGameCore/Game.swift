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
    
    /// effects queue that have to be resolved in order
    private var queue: [Effect] = []
    
    public init(_ initialState: State, queue: [Effect] = []) {
        self.state = CurrentValueSubject(initialState)
        self.queue = queue
    }
    
    public func input(_ move: Move) {
        // assert queue empty or waiting decision
        assert(queue.isEmpty || !state.value.decisions.isEmpty)
        
        queue.insert(move, at: 0)
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
        currState.event = nil
        
        /// if game is over, do nothing
        if currState.isOver {
            return false
        }
        
        /// if waiting decision and top queue is not a move, do nothing
        guard currState.decisions.isEmpty || queue.first is Move else {
            return false
        }
        
        /// assume pending decision is resolved
        currState.decisions.removeAll()
        
        /// process queued effect
        if !queue.isEmpty {
            let effect = queue.remove(at: 0)
            let result = effect.resolve(in: currState)
            handleEffectResult(result, currState: currState, effect: effect)
            return true
        }
        
        /// game idle, process eliminated player and game over
        if isGameOver(state: currState) {
            var newState = currState
            newState.isOver = true
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
    
    /// Handle effect execution result
    func handleEffectResult(_ result: Result<EffectOutput, Error>, currState: State, effect: Effect) {
        switch result {
        case let .success(output):
            var newState = currState
            
            if let updatedState = output.state {
                newState = updatedState
                newState.event = effect
            }
            
            if let effects = output.effects {
                queue.insert(contentsOf: effects, at: 0)
            }
            
            if let options = output.options {
                newState.decisions = options
            }
            
            state.send(newState)
            
        case let .failure(error):
            guard let event = error as? Event else {
                fatalError(.invalidError(error.localizedDescription))
            }
            
            var newState = currState
            newState.event = event
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
            .filter { state.canPlay($0, actor: actor).isSuccess }
            .map { Play(card: $0.id, actor: actor) }
        
        guard !moves.isEmpty else {
            return nil
        }
        
        return moves
    }
}
