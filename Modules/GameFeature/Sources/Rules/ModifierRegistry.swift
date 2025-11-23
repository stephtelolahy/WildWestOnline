//
//  ModifierRegistry.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

class ModifierRegistry {
    private var handlers: [GameFeature.Action.Modifier: ModifierHandler.Type] = [:]

    func register(_ modifier: GameFeature.Action.Modifier, handler: ModifierHandler.Type) {
        handlers[modifier] = handler
    }

    func handler(for modifier: GameFeature.Action.Modifier) -> ModifierHandler.Type? {
        handlers[modifier]
    }
}

#warning("Inject as GameFeature's dependency")
extension ModifierRegistry {
    nonisolated(unsafe) static let shared = ModifierRegistry()
}

public protocol ModifierHandler {
    static var id: GameFeature.Action.Modifier { get }

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action]
}

public extension ModifierHandler {
    static func registerSelf() {
        ModifierRegistry.shared.register(self.id, handler: self)
    }
}
