//
//  QueueModifierClient+Live.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//
public extension QueueModifierClient {
    static func live(handlers: [QueueModifierHandler.Type]) -> Self {
        let registry = QueueModifierRegistry(handlers: handlers)

        return .init(
            apply: registry.apply
        )
    }
}

struct QueueModifierRegistry {
    let dictionary: [Card.QueueModifier: QueueModifierHandler.Type]

    init(handlers: [QueueModifierHandler.Type]) {
        var dict: [Card.QueueModifier: QueueModifierHandler.Type] = [:]
        for type in handlers {
            dict[type.id] = type
        }
        dictionary = dict
    }

    func apply(_ action: GameFeature.Action, _ state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        guard let modifier = action.modifier else { fatalError("Missing modifier") }
        guard let handler = dictionary[modifier] else { fatalError("No handler for modifier: \(modifier)")}

        return try handler.apply(action, state: state)
    }
}

public protocol QueueModifierHandler {
    static var id: Card.QueueModifier { get }

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action]
}
