// swiftlint:disable:this file_name
//  EventLoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//
import Redux
import Combine

public let eventLoggerMiddleware: Middleware<GameState> = { state, _ in
    if let event = state.event {
        if event.isRenderable {
            print("✅ \(event.loggerDescription)")
        } else {
            print("➡️ \(event.loggerDescription)")
        }
    }

    if let error = state.error {
        print("❌ \(error.loggerDescription) on \(state.failed!.loggerDescription)")
    }

    return Empty().eraseToAnyPublisher()
}

private extension GameAction {
    var loggerDescription: String {
        String(describing: self).removingPackageName()
    }
}

private extension GameError {
    var loggerDescription: String {
        String(describing: self).removingPackageName()
    }
}

private extension String {
    func removingPackageName() -> String {
        if #available(iOS 16.0, *) {
            return self
                .replacing("Game.", with: "")
                .replacing("CardEffect.", with: "")
                .replacing("ArgCard.", with: "")
                .replacing("ArgPlayer.", with: "")
                .replacing("ArgNum.", with: "")
                .replacing("ArgCancel.", with: "")
                .replacing("ContextKey.", with: "")
                .replacing("GameAction.", with: "")
                .replacing("AttributeKey.", with: "")
        }
        return self
    }
}
