//
//  LoggerReducer.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 02/01/2025.
//

public func loggerReducer<State>() -> Reducer<State, Void> {
    { _, action, _  in
        print(action)
        return .none
    }
}
