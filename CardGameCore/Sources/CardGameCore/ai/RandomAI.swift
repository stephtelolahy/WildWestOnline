//
//  RandomAI.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 02/06/2022.
//

import Foundation
import Combine

public class RandomAI {
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    public func observe(game: GameProtocol) {
        game.state.sink { [weak self] in self?.processState($0, game: game) }.store(in: &cancellables)
    }
    
    private func processState(_ state: State, game: GameProtocol) {
        if !state.decisions.isEmpty,
           let bestMove = state.decisions.randomElement() {
            DispatchQueue.main.async {
                game.input(bestMove)
            }
        }
    }
}
