//
//  GameActionClient+Live.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

public extension GameActionClient {
    static func live(handlers: [GameActionHandler.Type]) -> Self {
        let registry = GameActionRegistry(handlers: handlers)
        return .init(
            handle: registry.handle
        )
    }
}

public protocol GameActionHandler {
    static var id: Card.ActionID { get }

    static func handle(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> GameFeature.State
}

private struct GameActionRegistry {
    let dictionary: [Card.ActionID: GameActionHandler.Type]

    init(handlers: [GameActionHandler.Type]) {
        var dict: [Card.ActionID: GameActionHandler.Type] = [:]
        for type in handlers {
            dict[type.id] = type
        }
        dictionary = dict
    }

    func handle(_ action: GameFeature.Action, _ state: GameFeature.State) throws(GameFeature.Error) -> GameFeature.State {
        guard let handler = dictionary[action.actionID] else {
            fatalError("No implementation for action: \(action.actionID)")
        }

        return try handler.handle(action, state: state)
    }
}
