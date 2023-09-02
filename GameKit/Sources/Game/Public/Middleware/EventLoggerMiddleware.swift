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
        print("❌ \(error.loggerDescription)")
    }

    return Empty().eraseToAnyPublisher()
}

public extension GameAction {
    var loggerDescription: String {
        String(describing: self).removingPackageName()
    }
}

public extension GameError {
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
                .replacing("CardArg.", with: "")
                .replacing("PlayerArg.", with: "")
                .replacing("NumArg.", with: "")
                .replacing("ContextKey.", with: "")
                .replacing("GameAction.", with: "")
                .replacing("AttributeKey.", with: "")
        }
        return self
    }
}
