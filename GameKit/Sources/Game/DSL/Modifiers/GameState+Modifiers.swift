//
//  GameState+Modifiers.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

public extension GameState {

    init(@GameAttributeBuilder components: () -> [GameAttribute] = { [] }) {
        components().forEach { $0.apply(to: &self) }
    }

    func isOver(_ value: String) -> Self {
        copy { $0.isOver = GameOver(winner: value) }
    }

    func turn(_ value: String) -> Self {
        copy { $0.turn = value }
    }

    func playCounters(_ value: [String: Int]) -> Self {
        copy { $0.playCounter = value }
    }

    func cardRef(_ value: [String: Card]) -> Self {
        copy { $0.cardRef = value }
    }
}

private extension GameState {
    func copy(closure: (inout Self) -> Void) -> Self {
        var copy = self
        closure(&copy)
        return copy
    }
}
