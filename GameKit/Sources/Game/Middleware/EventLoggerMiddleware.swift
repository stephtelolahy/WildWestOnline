// swiftlint:disable:this file_name
//
//  EventLoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//
// swiftlint:disable prefixed_toplevel_constant

import Combine
import Redux

public let eventLoggerMiddleware: Middleware<GameState> = { state, action in
    if let error = state.error {
        print("❌ \(error) on \(action)".removingNamespace())
    } else if let event = action as? GameAction {
        print("\(event.image) \(event)".removingNamespace())
    }

    return nil
}

private extension GameAction {
    var image: String {
        if isRenderable {
            "✅"
        } else {
            "➡️"
        }
    }
}

private extension String {
    func removingNamespace() -> String {
        if #available(iOS 16.0, *) {
            return self
                .replacing("Game.", with: "")
                .replacing("CardEffect.", with: "")
                .replacing("ArgCard.", with: "")
                .replacing("ArgPlayer.", with: "")
                .replacing("ArgNum.", with: "")
                .replacing("ArgCancel.", with: "")
                .replacing("GameAction.", with: "")
        }
        return self
    }
}
