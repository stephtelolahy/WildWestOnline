//
//  NumberResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.Number {
    func resolve(_ state: GameState) throws(GameError) -> Int {
        try resolver.resolve(state)
    }
}

private extension ActionSelector.Number {
    protocol Resolver {
        func resolve(_ state: GameState) throws(GameError) -> Int
    }

    var resolver: Resolver {
        switch self {
        case .value(let rawValue): Value(rawValue: rawValue)
        }
    }

    struct Value: Resolver {
        let rawValue: Int

        func resolve(_ state: GameState) throws(GameError) -> Int {
            rawValue
        }
    }
}
