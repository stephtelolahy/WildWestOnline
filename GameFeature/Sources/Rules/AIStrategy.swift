// swiftlint:disable force_unwrapping
//
//  AIStrategy.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

protocol AIStrategy {
    func evaluateBestMove(_ actions: [GameFeature.Action], state: GameFeature.State) -> GameFeature.Action
}

struct RandomStrategy: AIStrategy {
    func evaluateBestMove(_ actions: [GameFeature.Action], state: GameFeature.State) -> GameFeature.Action {
        actions.randomElement()!
    }
}

struct AgressiveStrategy: AIStrategy {
    func evaluateBestMove(_ actions: [GameFeature.Action], state: GameFeature.State) -> GameFeature.Action {
        #warning("Set AI value for playing card")
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

private extension GameFeature.Action {
    var selectedItem: String {
        switch name {
        case .preparePlay:
            return Card.name(of: playedCard)

        case .choose:
            let selection = chosenOption!
            return Card.name(of: selection)

        default:
            fatalError("unexpected action \(name)")
        }
    }
}
