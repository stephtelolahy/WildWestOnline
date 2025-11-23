//
//  QueueModifierRegistry.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

public class QueueModifierRegistry {
    private let handlers: [GameFeature.Action.QueueModifier: QueueModifierHandler.Type]

    public init(handlers: [QueueModifierHandler.Type]) {
        var result: [GameFeature.Action.QueueModifier: QueueModifierHandler.Type] = [:]
        for type in handlers {
            result[type.id] = type
        }
        self.handlers = result
    }

    func handler(for modifier: GameFeature.Action.QueueModifier) -> QueueModifierHandler.Type? {
        handlers[modifier]
    }
}

public protocol QueueModifierHandler {
    static var id: GameFeature.Action.QueueModifier { get }

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action]
}
