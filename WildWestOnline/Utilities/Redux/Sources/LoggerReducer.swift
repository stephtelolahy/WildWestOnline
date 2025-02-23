//
//  LoggerReducer.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 23/01/2025.
//

public func loggerReducer<State>(
    state: inout State,
    action: Action,
    dependencies: Void
) throws -> Effect {
    .run {
        print(action)
        return nil
    }
}
