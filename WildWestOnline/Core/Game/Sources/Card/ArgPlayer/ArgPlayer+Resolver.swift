//
//  ArgPlayer+Resolver.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

protocol ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> PlayerArgOutput
}

public extension ArgPlayer {
    enum Error: Swift.Error, Equatable {
        /// Not matching player
        case noPlayer(ArgPlayer)
    }
}

extension ArgPlayer {
    func resolve(state: GameState, ctx: EffectContext) throws -> PlayerArgOutput {
        let output = try resolver().resolve(state: state, ctx: ctx)
        let pIds: [String]
        switch output {
        case let .identified(identifiers):
            pIds = identifiers

        case let .selectable(options):
            pIds = options
        }

        guard pIds.isNotEmpty else {
            throw Error.noPlayer(self)
        }

        return output
    }

    func resolveUnique(state: GameState, ctx: EffectContext) throws -> String {
        if case let .id(pId) = self {
            return pId
        } else {
            let output = try resolve(state: state, ctx: ctx)
            guard case let .identified(pIds) = output else {
                throw Error.noPlayer(self)
            }

            guard pIds.count == 1 else {
                fatalError("unexpected")
            }

            return pIds[0]
        }
    }

    func resolve(
        state: GameState,
        ctx: EffectContext,
        copy: @escaping (String) -> GameAction
    ) throws -> [GameAction] {
        let resolved = try resolve(state: state, ctx: ctx)
        switch resolved {
        case let .identified(pIds):
            return pIds.map { copy($0) }

        case let .selectable(pIds):
            let actions = pIds.reduce(into: [String: GameAction]()) {
                $0[$1] = copy($1)
            }

            return try GameAction.validateChooseOne(
                pIds,
                actions: actions,
                chooser: ctx.sourceActor,
                type: .target,
                state: state,
                ctx: ctx
            )
        }
    }
}

/// Resolved player argument
enum PlayerArgOutput {
    /// Appply effect to well known object identifiers
    case identified([String])

    /// Must choose one of given object identifiers
    case selectable([String])
}

private extension ArgPlayer {
    // swiftlint:disable:next cyclomatic_complexity
    func resolver() -> ArgPlayerResolver {
        switch self {
        case .actor:
            PlayerActor()

        case .selectReachable:
            PlayerSelectReachable()

        case .selectAt(let distance):
            PlayerSelectAt(distance: distance)

        case .selectAny:
            PlayerSelectAny()

        case .next(let pivot):
            PlayerNext(pivot: pivot)

        case .damaged:
            PlayerDamaged()

        case .all:
            PlayerAll()

        case .others:
            PlayerOthers()

        case .offender:
            PlayerOffender()

        case .eliminated:
            PlayerEliminated()

        case .id:
            fatalError("unexpected")
        }
    }
}
