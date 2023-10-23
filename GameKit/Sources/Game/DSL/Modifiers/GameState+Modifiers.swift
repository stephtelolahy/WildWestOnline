//
//  GameState+Modifiers.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

public extension GameState {
    @available(*, deprecated, message: "Use builder instead")
    init(@GameAttributeBuilder components: () -> [GameAttribute] = { [] }) {
        components().forEach { $0.apply(to: &self) }
    }
}
