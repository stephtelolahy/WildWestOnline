//
//  QueueModifierRegistry.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

class QueueModifierRegistry {
    private var handlers: [GameFeature.Action.QueueModifier: QueueModifierHandler.Type] = [:]

    func register(_ modifier: GameFeature.Action.QueueModifier, handler: QueueModifierHandler.Type) {
        handlers[modifier] = handler
    }

    func handler(for modifier: GameFeature.Action.QueueModifier) -> QueueModifierHandler.Type? {
        handlers[modifier]
    }
}

#warning("Inject as GameFeature's dependency")
extension QueueModifierRegistry {
    nonisolated(unsafe) static let shared = QueueModifierRegistry()
}

public protocol QueueModifierHandler {
    static var id: GameFeature.Action.QueueModifier { get }

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action]
}

public extension QueueModifierHandler {
    static func registerSelf() {
        QueueModifierRegistry.shared.register(self.id, handler: self)
    }
}
