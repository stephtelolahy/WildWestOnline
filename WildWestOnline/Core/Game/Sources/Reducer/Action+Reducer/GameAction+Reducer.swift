//
//  GameAction+Reducer.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//

protocol GameActionReducer {
    func reduce(state: GameState) throws -> GameState
}
