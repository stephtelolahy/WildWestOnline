// swiftlint:disable:this file_name
//  GameLoopMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//
import Redux
import Combine

public let gameLoopMiddleware: Middleware<GameState> = { state, _ in
    if state.queue.isNotEmpty,
       state.isOver == nil,
       state.chooseOne == nil,
       state.active == nil {
        Just(state.queue[0]).eraseToAnyPublisher()
    } else {
        Empty().eraseToAnyPublisher()
    }
}
