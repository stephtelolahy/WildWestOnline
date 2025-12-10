//
//  Store+Binding.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 10/12/2025.
//
import SwiftUI

public extension Store {
    func binding<Value>(
        _ keyPath: KeyPath<State, Value>,
        send valueToAction: @escaping (Value) -> Action
    ) -> Binding<Value> {
        .init(
            get: { self.state[keyPath: keyPath] },
            set: { newValue in
                Task {
                    await self.dispatch(valueToAction(newValue))
                }
            }
        )
    }
}
