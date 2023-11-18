//  EventLoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//
import Combine
import Redux

public let eventLoggerMiddleware: Middleware<GameState> = { state, action in
    if let event = action as? GameAction {
        if event.isRenderable {
            print("✅ \(event)".removingNamespace())
        } else {
            print("➡️ \(event)".removingNamespace())
        }
    }

    if let error = state.error {
        print("❌ \(error) on \(action)".removingNamespace())
    }

    return nil
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
