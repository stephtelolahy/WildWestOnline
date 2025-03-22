//
//  AIStrategy.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public protocol AIStrategy {
    func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction
}

public struct RandomStrategy: AIStrategy {
    public init() {}

    public func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
        actions.randomElement()!
    }
}

public struct AgressiveStrategy: AIStrategy {
    public init() {}

    public func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
        // swiftlint:disable no_magic_numbers
        let itemValue: [String: Int] = [
            "bang": 3,
            "duel": 3,
            "gatling": 3,
            "panic": 1,
            "catBalou": 1,
            "endTurn": -1,
            "pass": -1
        ]

        return actions.shuffled().min { action1, action2 in
            let value1 = itemValue[action1.selectedItem] ?? 0
            let value2 = itemValue[action2.selectedItem] ?? 0
            return value1 > value2
        }!
    }
}

private extension GameAction {
    var selectedItem: String {
        switch name {
        case .preparePlay:
            return Card.extractName(from: payload.played)

        case .choose:
            guard let selection = payload.selection else {
                fatalError("Missing payload.selection")
            }
            return Card.extractName(from: selection)

        default:
            fatalError("unexpected action \(name)")
        }
    }
}
