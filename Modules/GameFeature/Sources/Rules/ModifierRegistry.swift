//
//  ModifierRegistry.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

public class ModifierRegistry {

    public typealias Modifier = GameFeature.Action.Modifier
    public typealias ModifierHandler = (GameFeature.State) -> GameFeature.State

    private var handlers: [Modifier: ModifierHandler] = [:]

    public func register(_ modifier: Modifier, handler : @escaping ModifierHandler) {
        handlers[modifier] = handler
    }

    func handler(for modifier: Modifier) -> ModifierHandler? {
        handlers[modifier]
    }
}

public extension ModifierRegistry {
    #warning("Inject this as GameFeature's dependency")
    nonisolated(unsafe) static let shared = ModifierRegistry()
}
