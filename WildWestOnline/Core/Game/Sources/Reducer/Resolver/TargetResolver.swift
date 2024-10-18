//
//  TargetResolver.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 01/10/2024.
//

extension TriggeredAbility.Selector.Target {
    func resolve(state: GameState, ctx: PendingAction) throws -> [String] {
        let targets = try resolver.resolve(state: state, ctx: ctx)
        guard targets.isNotEmpty else {
            throw TriggeredAbility.Selector.Error.noPlayer(self)
        }

        return targets
    }
}

private extension TriggeredAbility.Selector.Target {
    protocol Resolver {
        func resolve(state: GameState, ctx: PendingAction) throws -> [String]
    }

    private var resolver: Resolver {
        switch self {
        case .actor:
            fatalError()
        case .all:
            AllResolver()
        case .others:
            fatalError()
        case .next:
            fatalError()
        case .offender:
            fatalError()
        case .damaged:
            DamagedResolver()
        case .eliminated:
            fatalError()
        case .targeted:
            fatalError()
        }
    }

    struct AllResolver: Resolver {
        func resolve(state: GameState, ctx: PendingAction) throws -> [String] {
            state.playOrder
                .starting(with: ctx.actor)
        }
    }

    struct DamagedResolver: Resolver {
        func resolve(state: GameState, ctx: PendingAction) throws -> [String] {
            state.playOrder
                .starting(with: ctx.actor)
                .filter { state.player($0).isDamaged }
        }
    }
}

private extension Player {
    var isDamaged: Bool {
        health < maxHealth
    }
}
