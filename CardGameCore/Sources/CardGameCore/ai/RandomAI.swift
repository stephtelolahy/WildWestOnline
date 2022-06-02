//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 02/06/2022.
//

import Foundation
import Combine

class RandomAI {
    
    private var cancellables: [Cancellable] = []
    private var moveCounter = 0
    
    func observe(game: GameProtocol) {
        cancellables.append(game.state.sink { [unowned self] in processState($0, game: game) })
        cancellables.append(game.message.sink { [unowned self] in processMessage($0) })
    }
    
    private func processState(_ state: State, game: GameProtocol) {
        guard let decision = state.decisions.first?.value,
              let bestMove = decision.options.randomElement() else {
            return
        }
        
        DispatchQueue.main.async {
            game.input(bestMove)
        }
    }
    
    private func processMessage(_ message: Event) {
        if message is Move {
            moveCounter += 1
            print("\(moveCounter) - \(String(describing: message))")
        } else {
            print("\t\(String(describing: message))")
        }
    }
}
