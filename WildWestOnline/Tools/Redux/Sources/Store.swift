//
//  Store.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2024.
//

import Combine
import Foundation
import SwiftUI

/// `Store` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
public class Store<State: Equatable, Action: Equatable>: ObservableObject {
    @Published public internal(set) var state: State

    private let reducer: Reducer<State, Action>

    public init(
        initial state: State,
        reducer: @escaping Reducer<State, Action> = { state, _ in state }
    ) {
        self.state = state
        self.reducer = reducer
    }

    public func dispatch(_ action: Action) {
        let newState = reducer(state, action)
        state = newState
    }
}
