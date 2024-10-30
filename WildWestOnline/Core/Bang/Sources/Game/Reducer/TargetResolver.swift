//
//  TargetResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.Target {
    func resolve(_ state: GameState) throws(GameError) -> [String] {
        try resolver.resolve(state)
    }
}

private extension ActionSelector.Target {
    protocol Resolver {
        func resolve(_ state: GameState) throws(GameError) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .damaged: Damaged()
        }
    }

    struct Damaged: Resolver {
        func resolve(_ state: GameState) throws(GameError) -> [String] {
            []
        }
    }
}
