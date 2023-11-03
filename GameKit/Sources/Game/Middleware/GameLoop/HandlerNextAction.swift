//
//  HandlerNextAction.swift
//  
//
//  Created by Hugues Telolahy on 03/11/2023.
//

struct HandlerNextAction: GameActionHandler {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        switch action {
        case .setGameOver,
                .chooseOne,
                .activateCards:
            nil

        default:
            state.queue.first
        }
    }
}
