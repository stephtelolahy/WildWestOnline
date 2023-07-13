//
//  GameState+Modifiers.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

public extension GameState {

    init(@GameAttributeBuilder components: () -> [GameAttribute] = { [] }) {
        components().forEach { $0.update(game: &self) }
    }

    func isOver(_ value: String) -> Self {
        copy { $0.isOver = GameOver(winner: value) }
    }

    func turn(_ value: String) -> Self {
        copy { $0.turn = value }
    }

    func counters(_ value: [String: Int]) -> Self {
        copy { $0.playCounter = value }
    }

    func cardRef(_ value: [String: Card]) -> Self {
        copy { $0.cardRef = value }
    }

    func waiting(_ chooser: String, options: [String: GameAction]) -> Self {
        copy { $0.chooseOne = ChooseOne(chooser: chooser, options: options) }
    }

    func attribute(_ key: AttributeKey, _ value: Int) -> Self {
        copy { $0.attributes[key] = value }
    }

    func ability(_ value: String) -> Self {
        copy { $0.abilities.append(value) }
    }

    func queue(_ value: [GameAction]) -> Self {
        copy { $0.queue = value }
    }
}

private extension GameState {
    func copy(closure: (inout Self) -> Void) -> Self {
        var copy = self
        closure(&copy)
        return copy
    }
}
