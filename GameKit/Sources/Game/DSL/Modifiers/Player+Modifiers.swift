//
//  Player+Modifiers.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import Foundation

public extension Player {
    @available(*, deprecated, message: "Use builder instead")
    init(_ id: String = UUID().uuidString, @PlayerAttributeBuilder components: () -> [PlayerAttribute] = { [] }) {
        self.id = id
        components().forEach { $0.apply(to: &self) }
    }
}
