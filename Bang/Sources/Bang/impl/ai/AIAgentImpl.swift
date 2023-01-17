//
//  AIAgentImpl.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import Foundation
import Combine

public class AIAgentImpl: AIAgent {
    
    private let strategy: AIStrategy
    private var cancellables = Set<AnyCancellable>()
    
    public init(strategy: AIStrategy) {
        self.strategy = strategy
    }
    
    public func playAny(_ engine: Engine) {
        engine.state.sink { [weak self] ctx in
            self?.processState(ctx, engine: engine)
        }
        .store(in: &cancellables)
    }
    
    private func processState(_ ctx: Game, engine: Engine) {
        var moves: [Effect] = []
        if case let .success(effect) = ctx.event {
            if let activate = effect as? Activate {
                moves = activate.moves
            }
            if let chooseOne = effect as? ChooseOne {
                moves = chooseOne.getOptions()
            }
        }
        if !moves.isEmpty {
            let best = strategy.bestMove(among: moves, ctx: ctx)
            DispatchQueue.main.async {
                engine.input(best)
            }
        }
    }
}
