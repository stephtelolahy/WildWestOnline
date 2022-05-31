//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

import Combine

/// The game engine
protocol GameProtocol {
    
    /// state to be rendered
    var state: CurrentValueSubject<State, Never> { get }
    
    /// event or error to be rendered
    var message: PassthroughSubject<Event, Never> { get }
    
    /// input a move
    func input(_ move: Move)
    
    /// loop update
    func loopUpdate()
}

class Game: GameProtocol {
    
    var state: CurrentValueSubject<State, Never>
    
    var message: PassthroughSubject<Event, Never>
    
    /// commands queue
    private var commands: [Move] = []
    
    /// initialize game
    init(_ initialState: State) {
        state = CurrentValueSubject(initialState)
        message = PassthroughSubject()
    }
    
    func input(_ move: Move) {
        commands.append(move)
        loopUpdate()
    }
    
    func loopUpdate() {
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
            let result = command.dispatch(ctx: currState)
            send(result)
            return true
        }
        
        guard currState.decisions.isEmpty else {
            /// waiting decision, do nothing
            return false
        }
        
        guard let cardRef = currState.leafSequenceRef() else {
            /// game idle
            if currState.verifyGameOver() {
                currState.isGameOver = true
                state.send(currState)
            } else {
                generateActiveMoves()
            }
            return false
        }
        
        var sequence = currState.sequence(cardRef)
        
        guard !sequence.queue.isEmpty else {
            /// queued effects completed
            currState.sequences.removeValue(forKey: cardRef)
            state.send(currState)
            return true
        }
        
        /// process queued effect
        let effect = sequence.queue.remove(at: 0)
        currState.sequences[cardRef] = sequence
        state.send(currState)
        
        let result = effect.resolve(ctx: currState, cardRef: cardRef)
        send(result)
        return true
    }
    
    /// Emit state changes and message
    func send(_ update: Update) {
        if let newState = update.state {
            state.send(newState)
        }
        
        if let newEvent = update.event {
            message.send(newEvent)
        }
    }
    
    /// Generate active moves of current turn player
    func generateActiveMoves() {
        var currState = state.value
        guard let turn = currState.turn else {
            return
        }
        
        let actorObj = currState.player(turn)
        let moves = (actorObj.common + actorObj.hand)
            .map { generateActiveMoves(card: $0, actor: turn, ctx: currState) ?? [] }
            .flatMap { $0 }
        
        guard !moves.isEmpty else {
            return
        }
        
        currState.decisions[turn] = Decision(options: moves)
        
        state.send(currState)
    }
    
    func generateActiveMoves(card: Card, actor: String, ctx: State) -> [Move]? {
        guard canPlay(card: card, actor: actor, ctx: ctx) else {
            return nil
        }
        
        if let target = card.target {
            guard case let .success(pIds) = Args.resolveTarget(target, ctx: ctx, actor: actor) else {
                return nil
            }
            
            return pIds.map { Play(card: card.id, actor: actor, target: $0) }
        } else {
            return [Play(card: card.id, actor: actor)]
        }
    }
    
    func canPlay(card: Card, actor: String, ctx: State) -> Bool {
        if ctx.turnNotStarted,
           card.activationMode != .activePrepareTurn {
            return false
        }
        
        if !ctx.turnNotStarted,
           card.activationMode != .active {
            return false
        }
        
        let sequence = Sequence(actor: actor, card: card)
        for playReq in card.canPlay {
            if case .failure = playReq.verify(ctx: ctx, sequence: sequence) {
                return false
            }
        }
        
        return true
    }
}

private extension State {
    
    /// Get leaf `PlaySequence`
    func leafSequenceRef() -> String? {
        sequences.leaf
    }
    
    /// Check if game is Over
    func verifyGameOver() -> Bool {
        #warning("implement game over")
        return players.contains { $0.value.health == 0 }
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
