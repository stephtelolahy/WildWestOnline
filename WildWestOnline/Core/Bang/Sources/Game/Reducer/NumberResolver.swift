//
//  NumberResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.Number {
    func resolve(_ state: GameState) -> Int {
        resolver.resolve(state)
    }
}

private extension ActionSelector.Number {
    protocol Resolver {
        func resolve(_ state: GameState) -> Int
    }

    var resolver: Resolver {
        switch self {
        case .value(let rawValue): Value(rawValue: rawValue)
        case .activePlayers: ActivePlayers()
        }
    }

    struct Value: Resolver {
        let rawValue: Int

        func resolve(_ state: GameState) -> Int {
            rawValue
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(_ state: GameState) -> Int {
            state.playOrder.count
        }
    }
}
