//
//  LoggerReducer.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 02/01/2025.
//

public func loggerReducer<State, Action>() -> Reducer<State, Action, Void> {
    { _, action, _  in
        print(action)
        return .none
    }
}
