//
//  EventLoggerMiddleware.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//

import Combine
import Redux

public final class EventLoggerMiddleware: Middleware<GameState> {
    override public func handle(action: Action, state: GameState) -> AnyPublisher<Action, Never>? {
        guard let action = action as? GameAction else {
            return nil
        }

        if let error = state.error {
            print("❌ \(error) on \(action)".removingNamespace())
        } else {
            let image: String = if action.isRenderable {
                "✅"
            } else {
                "➡️"
            }
            print("\(image) \(action)".removingNamespace())
        }

        return nil
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
