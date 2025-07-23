//
//  AIStrategy.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

protocol AIStrategy {
    func evaluateBestMove(_ actions: [Card.Effect], state: GameFeature.State) -> Card.Effect
}

struct RandomStrategy: AIStrategy {
    func evaluateBestMove(_ actions: [Card.Effect], state: GameFeature.State) -> Card.Effect {
        actions.randomElement()!
    }
}

struct AgressiveStrategy: AIStrategy {
    func evaluateBestMove(_ actions: [Card.Effect], state: GameFeature.State) -> Card.Effect {
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

private extension Card.Effect {
    var selectedItem: String {
        switch name {
        case .preparePlay:
            return Card.extractName(from: playedCard)

        case .choose:
            let selection = chosenOption!
            return Card.extractName(from: selection)

        default:
            fatalError("unexpected action \(name)")
        }
    }
}
